# chef bash_completion functions
# Not hard-coded to any particular version of knife, they instead query knife for available options
# Author: Dmitriy Vi <vindimy@gmail.com>

# knife function definitions

_knife ()
{
        local c=1 word
        local numwords=0 cmd="knife"

        while [ $c -le $COMP_CWORD ]; do
                word="${COMP_WORDS[c]}"
                case "$word" in
                        --*)
                                ;;
                        *)
                                cmd=$cmd" "$word
                                numwords=$((++numwords))
                                ;;
                esac
                c=$((++c))
        done

        local opts subcmd
        word="${COMP_WORDS[COMP_CWORD]}"
        case "$word" in
                --*)
                        if [ $COMP_CWORD -ge 2 ]; then
                                subcmd=${COMP_WORDS[1]}
                        fi
                        opts=$(_knife_opts "$subcmd")
                        if [ "$opts" == "" ]; then
                                opts="--help"
                        fi
                        ;;
                *)
                        opts=$(_knife_cmds "$cmd" $((++numwords)))
                        case "$opts" in
                                BAG)
                                        opts=$(knife data bag list)
                                        ;;
                                CLIENT)
                                        opts=$(knife client list)
                                        ;;
                                COOKBOOK)
                                        opts=$(knife cookbook list | awk '{ print $1 }')
                                        ;;
                                ENVIRONMENT)
                                        opts=$(knife environment list)
                                        ;;
                                FILE)
                                        opts=$(ls)
                                        ;;
                                NODE)
                                        opts=$(knife node list)
                                        ;;
                                ROLE)
                                        opts=$(knife role list)
                                        ;;
                                SERVER_NAME)
                                        opts=$(knife cs server list | sed '1d' | awk '{ print $1 }')
                                        ;;
                                "(options)")
                                        opts=""
                                        ;;
                        esac
                        ;;
        esac
        COMPREPLY=(${COMPREPLY[@]:-} $(compgen -W "$opts" -- "$word"))
}

_knife_cmds ()
{
        knife --help | grep ^knife | grep "$1" | awk -v col=$2 '{ print $col }' | sort | uniq
}

_knife_opts ()
{
        knife $1 --help | grep -oh -e "--\w* " -e "--\w*-\w*" | sort | uniq
}


# complete statements

complete -o default -F _knife knife