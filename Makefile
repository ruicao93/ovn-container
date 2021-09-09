.PHONY: image
image:
	docker build -f image/Dockerfile -t caorui/ovn:21.06 .
