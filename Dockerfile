# QEMU HTML documentation builder
#
# Periodically rebuilds the QEMU HTML documentation from qemu.git/master.  The
# output is then rsynced to a web server.
#
# How to build:
# 1. Generate an ssh key pair (./id_rsa) in the same directory as the Dockerfile.
# 2. Add the ssh public key to the web host using:
#   $ echo 'command="rsync --server -logDtprce.iLs . /home/qemu-docs/public",no-agent-forwarding,no-port-forwarding,no-pty,no-X11-forwarding ...'
#   (where the '...' is the ssh public key)
# 3. Run "docker build ."

FROM fedora:31
RUN dnf -y update && dnf -y install diffutils findutils git make gcc flex bison glib2-devel pixman-devel texinfo python3-sphinx rsync && dnf clean all
RUN useradd --create-home qemu-docs
RUN install -d -o qemu-docs -g qemu-docs -m 0700 /home/qemu-docs/.ssh
COPY id_rsa /home/qemu-docs/.ssh/id_rsa
RUN chown qemu-docs:qemu-docs /home/qemu-docs/.ssh/id_rsa
COPY conf/known_hosts /home/qemu-docs/.ssh/known_hosts
RUN chown qemu-docs:qemu-docs /home/qemu-docs/.ssh/known_hosts
COPY update-docs.sh /home/qemu-docs/update-docs.sh
RUN chown qemu-docs:qemu-docs /home/qemu-docs/update-docs.sh
COPY run.sh /home/qemu-docs/run.sh
RUN chown qemu-docs:qemu-docs /home/qemu-docs/run.sh
USER qemu-docs
WORKDIR /home/qemu-docs
CMD ["/home/qemu-docs/run.sh"]
