### This .bash_profile should be sourced _after_ any system-specific profiles are sourced.
### E.g., after profile file that sources things like AWS keys or github keys
# source $HOME/.bash_profile_secrets
# source $HOME/bin/.bash_profile

###########################################################
### Terminal
alias ll='ls -Gl'
alias la='ls -Gla'

alias gi='git'
alias gits='git status'
alias gitss='git status -s'

alias bc='bc -l'

alias to='tee out'

alias lsofi='lsof -Pn -i'

alias gradle='./gradlew'
alias gw='./gradlew'

export EDITOR=vim

# include optional git branch in green, then current directory in yellow
function color_my_prompt() {
    local __git_branch_color="\[\033[32m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    export PS1="\u@\h $__git_branch_color$__git_branch\[\033[38;5;11m\]\W\[$(tput sgr0)\]\$ "
}
# this is the PS1 I want to use on remote machines.  It's here for easy copy access
export REMOTE_PS1='"[\u@\[\033[32m\]\h\033[0m \W]\$ "'
color_my_prompt

if [[ -f $HOME/.git-completion.bash ]] ; then
    . $HOME/.git-completion.bash
fi

# use the github API
if [[ -n "$HOMEBREW_GITHUB_API_TOKEN" ]] ; then
    alias github="curl -i -H 'Authorization: token $HOMEBREW_GITHUB_API_TOKEN'"
fi

export PATH=$PATH:$HOME/bin

###########################################################
### Python
export PIP_REQUIRE_VIRTUALENV=true


###########################################################
### Ruby
# local gem install path (if installed with 'gem install --user-install <gemname>'
RUBY_PATH=$HOME/.gem/ruby/2.0.0/bin
if [[ -e "$RUBY_PATH" ]] ; then
    export PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin
fi

###########################################################
### Node/NPM/yarn
# add 'node' and 'yarn' from Maven repository onto PATH
if [[ -n "$NODE_VERSION" ]] && [[ -n "$YARN_VERSION" ]] ; then
    node_bin_dir=$HOME/.m2/repository/node-${NODE_VERSION}-${YARN_VERSION}/node/yarn/dist/bin
    if [[ -d "$node_bin_dir" ]] ; then
        export PATH="$PATH:$HOME/.m2/repository/node-${NODE_VERSION}-${YARN_VERSION}/node/yarn/dist/bin"
    fi
fi

###########################################################
### Java
export JAVA7_HOME=$(/usr/libexec/java_home -v 1.7 2> /dev/null)
export JAVA8_HOME=$(/usr/libexec/java_home -v 1.8 2> /dev/null)
export JAVA_HOME="$JAVA7_HOME"

# java respecting JAVA_HOME:  /System/Library/Frameworks/JavaVM.framework/Versions/Current/Commands/java
java7_path=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/bin/java
java8_path=/Library/Java/JavaVirtualMachines/jdk1.8.0_74.jdk/Contents/Home/bin/java
java7crypto_path=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk-crypto/Contents/Home

export MAVEN_OPTS='-XX:MaxPermSize=1G -Xms2G -Xmx2G'
export SKIP_STUFF='-Dfindbugs.skip -Dcheckstyle.skip=true -Denforcer.skip=true -Dmaven.javadoc.skip=true'
export SKIP_FRONTEND='-Dskip.yarn'
export ALPHABETIC='-Dsurefire.runOrder=alphabetical'
export REV_ALPHABETIC='-Dsurefire.runOrder=reversealphabetical'

# Any SBT options can go here
export SBT_OPTS="$SBT_OPTS -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

# compile with 7, run surefire tests with 8
alias mvn8test="mvn -Dsurefire.jvm=${java8_path} -Dfailsafe.jvm=${java8_path}"
# compile and run tests with 8
alias mvn8all="JAVA_HOME='' mvn -Denforcer.requireJavaVersion.max=1.9"
