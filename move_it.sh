#!/bin/bash


####  _____ ______       ________      ___      ___  _______           ___      _________  
#### |\   _ \  _   \    |\   __  \    |\  \    /  /||\  ___ \         |\  \    |\___   ___\  
#### \ \  \\\__\ \  \   \ \  \|\  \   \ \  \  /  / /\ \   __/|        \ \  \   \|___ \  \_| 
####  \ \  \\|__| \  \   \ \  \\\  \   \ \  \/  / /  \ \  \_|/__       \ \  \       \ \  \ 
####   \ \  \    \ \  \   \ \  \\\  \   \ \    / /    \ \  \_|\ \       \ \  \       \ \  \
####    \ \__\    \ \__\   \ \_______\   \ \__/ /      \ \_______\       \ \__\       \ \__\
####     \|__|     \|__|    \|_______|    \|__|/        \|_______|        \|__|        \|__|
###                                                                                       
### Move It Version: 0.1.0
### Usage:
###   move_it [option] <input>
###
### Options:
###   <input>   File or path to deal.
###   -h        Show this message.
###   -d        Specify the output path. 
###   -v        Verbose. 
###   -R        Process all subfolders recursively.
###   -n        Do not process subfolders.
###   -V        Show version.


################################ about use ####################################
help() {
    sed -rn 's/^### //;T;p' "$0"
    exit 1
}

if [[ $# == 0 ]] || [[ "$1" == "-h" ]]; then
    help
fi
##############################################################################

################################ about log ####################################
log_err=1
log_info=2
log_dbg=3

log_level=1

COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[33m"
CLR_COLOR="\033[0m"

mi_log() {
    echo -n "[move_it]: "
    echo -n $@
}

mi_err() {
    if [ ${log_level} -ge ${log_err} ]; then
        echo -ne "${COLOR_RED}"
        mi_log $@
        echo -e "${CLR_COLOR}"
    fi
}

mi_info() {
    if [ ${log_level} -ge ${log_info} ]; then
        echo -ne "${COLOR_GREEN}"
        mi_log $@
        echo -e "${CLR_COLOR}"
    fi
}

mi_dbg() {
    if [ ${log_level} -ge ${log_dbg} ]; then
        echo -ne "${COLOR_YELLOW}"
        mi_log $@
        echo -e "${CLR_COLOR}"
    fi
}
##############################################################################


################################ about conf ####################################

config_def_path=${HOME}/move_it_finish
mi_compress=(zip tar gz 7z tgz arc arj taz \
    lha lz4 lzh lzma tlz tzo t7z z dz \
    lrz lz lzo xz zst tzst bz2 bz tbz tbz2 \
    iso)
mi_image=(jpg jpeg bmp png ppm\
    gif pbm pgm tga xbm tif tiff \
    svg svgz psd)
mi_video=(mkv webm mjpg mjpeg m2v ogm m4v \
    mp4v vob qt nuv wam rm rmvb flv avi\
    yuv mp4)
mi_audio=(mp3 flac aac mid midi wav)
mi_doc=(doc docx xps md txt ps diff)
mi_excel=(xls xlsx csv)
mi_ppt=(ppt pptx)
mi_font=(ttf otf)
mi_code=(sh bash py c cpp cc cxx h hpp s)
mi_web=(html css js)
mi_ebook=(mobi epub pdf)
mi_nn=(caffemodel onnx prototxt pb)
mi_bin=(deb appimage bin dat)
mi_apk=(apk)
mi_lib=(so a)

mi_all_ff=(mi_compress mi_image mi_video mi_audio mi_doc mi_excel \
    mi_ppt mi_font mi_code mi_web mi_ebook mi_nn mi_bin mi_apk mi_lib)

mi_code_post() {
    #cat ${1}
    echo > /dev/null
}

mi_dir_post() {
    # ls ${1}
    echo > /dev/null
}

mi_image_post() {
    # file ${1}
    echo > /dev/null
}

mi_video_post() {
    # file ${1}
    echo > /dev/null
}

get_file_type() {

    if [ $# -ne 1 ];then
        echo "others"
        return 0 
    fi

    ext_name=${1}

    for ff in ${mi_all_ff[@]}
    do
        ffs=${!ff}
        eval ffs=\( \${${ff}[@]} \)
        for i in ${ffs[@]}
            do
                if [ "${ext_name}" == "${i}" ]; then
                    echo "${ff:3}"
                    return 0
                fi
            done
    done

    echo "others"
    return 0 
}
##############################################################################


################################ about args ####################################

parse_arg() {

    while getopts :vVhRnd: opt
    do
    case "$opt" in
        v) let log_level=log_level+1 ;;
        d) out_path=$OPTARG ;;
        n) let process_dir=0 ;;
        R) let recursion=1 ;;
        V) help ;;
        h) help ;;
        *) ;;
    esac
    done

    shift $[ $OPTIND - 1 ]

    for param in "$@"
    do
        all_todo+="${param} "
    done
}

##############################################################################


################################ about process #################################
mi_process_file() {

    fn=$(basename ${1})
    ext_name=${1##*.}
    ft=$(get_file_type ${ext_name})

    mi_dbg "${1} -> ${2}/${ft}"

    ls ${2}/${ft} > /dev/null 2>&1 || mkdir -p ${2}/${ft}
    mv ${1} ${2}/${ft}

    if [ "$(type -t mi_${ft}_post)" == function ]; then

        pushd ${2}/${ft} > /dev/null 2>&1
            mi_info "Post process ${fn} with mi_${ft}_post!"
            mi_${ft}_post ${fn}
        popd > /dev/null 2>&1

    fi
}

mi_process_dir() {
    IFS=$(echo -en "\n\b")
    dir_out_path=${2}/dirs
    for i in `ls ${1}`
    do
        in_file=${1}/${i}
        if [ -f ${in_file} ];then
            mi_process_file ${in_file} ${2}
        fi
 
        if [ -d ${in_file} ];then
    
            if [ ${process_dir} -eq 0 ];then
                mi_dbg "Do not process dir!"
                continue 
            fi

            if [ ${recursion} -eq 0 ];then
                mi_dbg "${in_file} -> ${dir_out_path}"
                ls ${dir_out_path} > /dev/null 2>&1 || mkdir -p ${dir_out_path}
                mv ${in_file} ${dir_out_path}
            else
                mi_info "Recursion process ${in_file}!"
                mi_process_dir ${in_file} ${2} 
            fi
        fi
    done
}


mi_process() {
    if [ -f ${1} ];then
        mi_process_file $@
    elif [ -d ${1} ];then
        mi_process_dir $@ 
    else
        mi_err "Input path is err!"
    fi
}

##############################################################################


################################ about main ####################################

process_dir=1
recursion=0
out_path=${config_def_path}
all_todo=()
parse_arg $@

mi_dbg "Out path is ${out_path}"

for i in ${all_todo}
do
    mi_info "Process ... ${i}"
    mi_process ${i} ${out_path}
done

##############################################################################
