_tunnel_py()
{
    local opts="init add ls up down edit" i=1

    case ${COMP_WORDS[i]} in
        init)
            if [[ "$COMP_CWORD" -ge "$i" ]]; then
                opts=""
            else
                opts="-h --help"
            fi
            ;;
        add)
            if [[ $(( COMP_CWORD % 2 )) == 0 ]]; then
                opts="-n -H -p -l -g --name --host --port --local-port --gateway"
            else
                opts=""
            fi
            ;;
        edit)
            if [[ COMP_CWORD == 2 ]]; then
                opts=$(tunnel ls | cut -d ':' -f1)
            elif [[ $(( COMP_CWORD % 2 )) == 1 ]]; then
                opts="-H -p -l -g --host --port --local-port --gateway"
            else
                opts=""
            fi
            ;;

        ls)
            if [[ $i -eq "$COMP_CWORD - 1" ]]; then
                opts="-s"
            else
                ((i++))
                if [[ "$i" -eq "$COMP_CWORD - 1" ]]; then
                    opts="all up down"
                else
                    opts=""
                fi
            fi
            ;;
        up)
            opts=$(tunnel ls -s down | cut -d ':' -f1)
            ;;
        down)
            opts=$(tunnel ls -s up | cut -d ':' -f1)
            ;;
    esac

    COMPREPLY=( $(compgen -W "$(echo $opts | xargs -n1 | sort -g | xargs)" -- "${COMP_WORDS[COMP_CWORD]}") )
    return 0
}
complete -F _tunnel_py tunnel
# Run this >>>>>>>>>>>>>>>>
# eval "`tunnel complete`"
