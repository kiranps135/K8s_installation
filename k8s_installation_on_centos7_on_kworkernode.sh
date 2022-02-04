#!/bin/bash

#k8s installation on centos 7 for worker Node

# Disable the firewall

systemctl disable firewalld
systemctl stop firewalld

#Disable the swap

swapoff -a; sed -i '/swap/d' /etc/fstab

#Disable SELINUX

setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Update sysctl settings for Kubernetes networking

cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Install Docker Engine

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-19.03.12 
systemctl enable --now docker

# Add kubernetes repo

cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes components

yum install -y kubeadm kubelet kubect

# Enable and Start kubelet service

systemctl enable --now kubelet


