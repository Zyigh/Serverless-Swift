FROM ibmcom/swift-ubuntu 

WORKDIR /ServerlessSwift
ADD / .

CMD swift run
