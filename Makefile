# 格式一：
# target ... : prerequisites ...
# <Tab>command
# 格式二：target ... : prerequisites ...;command

# Make 命令运行时，如果不指定“目标”，默认执行 Makefile 文件的第一个“目标”。
# 一般将 help 作为 Makefile 的第一个“伪目标”，我们可以执行 make 或 make help 命令，输出使用方法。

# 如果我们不想打印出执行的命令，可以在命令前面加上 @ 符号。

APP="youta"
# 定义伪目标 这定义完后 下边可以直接定义目标要执行的指令，如果运行 到时候不置顶目标 则默认实用第一个定义的伪目标
# 也可以单独定义伪目标
.PHONY: help all run clean

help:
	@echo "usage make <option>"
	@echo "make help - '显示帮助说明'"
	@echo "make mac - '编译go代码，生成mac平台的二进制文件'"
	@echo "make linux - '编译go代码，生成linux平台的二进制文件'"
	@echo "make windows - '编译go代码，生成windows平台的二进制文件'"
	@echo "make tidy - '执行 go mod tidy'"
	@echo "make run '直接运行go代码'"
	@echo "make clean - '清理生成的二进制代码'"
	@echo "make all - '编译多平台二进制代码'"

#执行go代码格式化 静态检查
.PHONY: gotool
gotool:
	@go fmt ./
	@go vet ./
##linux: 编译linux平台可执行文件
#.PHONY: linux # 这里可以重新定义伪目标
linux:gotool
	CGO_ENABLED=0 GOOS="linux" GOARCH="amd64" go build -o ./bin/${APP}-linux64 ./main.go
#.PHONY: mac
mac:gotool
	CGO_ENABLED=0 GOOS="darwin" GOARCH="amd64" go build -o ./bin/${APP}-darwin64 ./main.go
#.PHONY: win
windows:gotool
	CGO_ENABLED=0 GOOS="windows" GOARCH="amd64" go build -o ./bin/${APP}-windows64.exe ./main.go

# 使用的时候定义伪目标
.PHONY: tidy
tidy:
	@go mod tidy

# 单元测试
.PHONY:test
	@go test


all:linux mac windows

build:gotool
	@go build -o ./bin${APP} ./main.go
run:gotool
	@go run ./

# 清理二进制文件 实用ssh名
clean:
	@if [ -f ./bin/${APP}-linux64 ] ;then rm ./bin/${APP}-linux64; fi
	@if [ -f ./bin/${APP}-darwin64.exe ] ; then rm ./bin/${APP}-darwin64.exe; fi
	@if [ -f ./bin/${APP}-windows64.exe ] ; then rm ./bin/${APP}-windows64.exe; fi
