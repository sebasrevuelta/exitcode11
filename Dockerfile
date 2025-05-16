# syntax=docker/dockerfile:1
FROM amazonlinux:2

# 1-10: Basic setup
ENV TERRAFORM_VERSION=1.5.0
ENV AWSCLI_VERSION=2.13.6

RUN yum update -y
RUN yum install -y \
    tar \
    gzip \
    shadow-utils \
    which \
    zip

# 11-20: Add dependencies and system tools
RUN yum install -y \
    sudo \
    curl \
    wget \
    jq \
    unzip \
    git

# Create a user for security
RUN useradd -m terraform
USER terraform
WORKDIR /home/terraform

# 21-30: Download and install Terraform manually
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN sudo mv terraform /usr/local/bin/
RUN rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# 31-40: Install AWS CLI manually
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sudo ./aws/install
RUN rm -rf awscliv2.zip aws

# 41: Maybe a prep step
RUN echo "Almost ready..."

# 42: The line in question
RUN sudo yum install -y unzip curl git terraform awscli jq && yum clean all && rm -rf /var/cache/yum
