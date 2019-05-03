FROM ibmcom/swift-ubuntu 

WORKDIR /ServerlessSwift
ADD / .
RUN swift build -c release

CMD ./.build/x86_64-unknown-linux/release/Serverless-Swift
