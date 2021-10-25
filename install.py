import yaml
import os
import shutil
import glob

install_dir = "/root/.road-runner"

if __name__ == '__main__':

    # delete the installation directory if it exists
    isExist = os.path.exists(install_dir)
    if isExist:
        shutil.rmtree(install_dir)
    
    # create the installation director
    os.mkdir(install_dir)
    
    # always cd into install_dir
    os.chdir(install_dir)
    
    # install git
    os.system("yum install -y git")
    
    # install road-runner distribution
    os.system("git clone https://github.com/rstober/dotfiles.git %s" % install_dir)
    
    # read in client configuration
    stream = open("install_config.yaml", 'r')
    dictionary = yaml.full_load(stream)
    
    # load the python3 module
    exec(open('/cm/local/apps/environment-modules/4.5.3/Modules/default/init/python.py').read())
    module('load','python3')
    module('list')
    
    # install ansible base
    os.system('pip install ansible==' + dictionary["ansible_version"])
    
    # install the brightcomputing.bcm Ansible collection
    os.system("ansible-galaxy collection install brightcomputing.bcm")
    
    # filelist = glob.glob(install_dir + '/*')
    # for f in filelist:
        # print(f)
    
    shutil.copyfile("cmshrc", "/root/.cmshrc")
    shutil.copyfile("bookmarks-cmsh", "/root/.bookmarks-cmsh")
    shutil.copyfile("du.cmsh", "/root/.cm/cmsh/du.cmsh")
    shutil.copyfile("cu.cmsh", "/root/.cm/cmsh/cu.cmsh")
    shutil.copyfile("si.cmsh", "/root/.cm/cmsh/si.cmsh")
    shutil.copyfile("dp.cmsh", "/root/.cm/cmsh/dp.cmsh")
    shutil.copyfile("ansible.cfg", "/root/.ansible.cfg")
    
    if deploy_jupyter:
        # download the AWS CLI
        os.system("curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"")
        shutil.unpack_archive(awscliv2.zip, install_dir, zip)
    
    
    #print(dictionary["cloned_software_image_name"])
    # for key, value in dictionary.items():
        # print (key + " : " + str(value))