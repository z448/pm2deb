export PATH=$PWD:$PWD/bin:$PATH
export PERL5LIB=$PWD/lib:$PWD/local/lib:$PERL5LIB
    
function setup {
    rm -rf $PWD/local
    rm -rf $PWD/build
}

alias cypan_test='cpanm --reinstall -l build/usr/local/lib/perl5 Pegex'

    echo -e '   - source this file'
    echo -e "\e[33m. env.sh \e[0m"
    echo -n '   - to install dependencies use Carton '
    echo -e "\n\e[33mcarton install \e[0m"
    echo -n '   - if you dont have it install it via cpan '
    echo -e "\n\e[33mcpan Carton \e[0m"
    echo '   - anytime you want to reset env, do '
    echo -e "\e[31msetup \e[0m\n\n"
