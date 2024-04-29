pipeline {
    agent {
        node { label'workstation' }
    }
    options {
        // Limit build history with buildDiscarder option:
        // daysToKeepStr: history is only kept up to this many days.
        // numToKeepStr: only this many build logs are kept.
        // artifactDaysToKeepStr: artifacts are only kept up to this many days.
        // artifactNumToKeepStr: only this many builds have their artifacts kept.
        buildDiscarder(logRotator(numToKeepStr: '1'))
        // Enable timestamps in build log console
        timestamps()
        // Maximum time to run the whole pipeline before canceling it
        timeout(time: 3, unit: 'HOURS')
        // Use Jenkins ANSI Color Plugin for log console
        ansiColor('xterm')
        // Limit build concurrency to 1 per branch
        disableConcurrentBuilds()
    }
    stages
    {
        stage('Prepare dependencies') {
            steps {
                sh'''
                cd antd/luasocket && git stash || true
                cd $WORKSPACE
                git submodule update --init
                make clean || true
                rm -rf build/* || true
                mkdir build || true
                '''
            }
        }
        stage('Build AMD64)') {
            agent {
                docker {
                    image 'xsangle/ci-tools:latest'
                    reuseNode true
                    args ' --device /dev/fuse --privileged '
                }
            }
            steps {
                sh'''
                DESTDIR=$(realpath build) \
                    ARCH=amd64 \
                    RUSTUP_HOME=/opt/rust/rustup \
                    CARGO_HOME=/opt/rust/cargo \
                    make all deb appimg
                '''
            }
        }
        stage('Build ARM64)') {
            agent {
                docker {
                    image 'xsangle/ci-tools:latest'
                    reuseNode true
                    args ' --device /dev/fuse --privileged '
                }
            }
            steps {
                sh'''
                DESTDIR=$(realpath build) \
                    ARCH=arm64 \
                    RUSTUP_HOME=/opt/rust/rustup \
                    CARGO_HOME=/opt/rust/cargo \
                    make all deb appimg
                '''
            }
        }
        stage('Build ARM)') {
            agent {
                docker {
                    image 'xsangle/ci-tools:latest'
                    reuseNode true
                    args ' --device /dev/fuse --privileged '
                }
            }
            steps {
                sh'''
                DESTDIR=$(realpath build) \
                    ARCH=arm \
                    RUSTUP_HOME=/opt/rust/rustup \
                    CARGO_HOME=/opt/rust/cargo \
                    make all deb appimg
                '''
            }
        }
        stage('Checking build)') {
            steps {
                sh'''
                ./scripts/ckarch.sh build
                '''
            }
        }
        stage('Build docker') {
            steps {
                script {
                    if (env.TAG_NAME) {
                        sh'''
                        DOCKER_TAG=$TAG_NAME DOCKER_IMAGE=iohubdev/antos make docker
                        '''
                    } else {
                        echo "Regular commit doing nothing"
                    }
                }
            }
        }
        stage('Copy doc') {
            steps {
                sh'''
                DOCDIR=/home/dany/public/antos-release/doc/ make doc
                SDKDIR=/home/dany/public/antos-release/sdk/ make sdk
                '''
            }
        }
        stage('Copy Binaries') {
            steps {
                sh'''
                BINDIR="/home/dany/public/antos-release/binaries/"
                find ./build/ -name "*.deb" -exec install -Dm 755 "{}" "$BINDIR/deb" \\;
                find ./build/ -name "*.AppImage" -exec install -Dm 755 "{}" "$BINDIR/appimg" \\;
                '''
            }
        }
        stage('Archive') {
            steps {
                script {
                    archiveArtifacts artifacts: 'build/', fingerprint: true
                }
            }
        }
    }
}
