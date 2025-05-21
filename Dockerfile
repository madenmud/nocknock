FROM ubuntu:20.04

# 의존성 설치
RUN apt-get update && apt-get install -y \
    curl git build-essential make gcc clang libssl-dev libleveldb-dev \
    && rm -rf /var/lib/apt/lists/*

# Rust 설치
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Nockchain 소스 코드 복사
WORKDIR /nockchain
RUN git clone https://github.com/zorp-corp/nockchain.git .

# Nockchain 노드 및 월렛 빌드
RUN make build-hoon-all && make build && make install-nockchain

# 지갑 데이터 디렉토리 생성
RUN mkdir -p /nockchain/data/wallet

# 스크립트 디렉토리 생성
RUN mkdir -p /nockchain/scripts

# 환경 변수 설정
ENV PATH="/nockchain/target/release:${PATH}"

# 컨테이너 시작 시 쉘 실행
CMD ["/bin/bash"]
