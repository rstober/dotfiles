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
    
    stream = open("install_config.yaml", 'r')
    dictionary = yaml.full_load(stream)
    
    os.system("curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"")
    
    filelist = glob.glob(install_dir + '/*')
    for f in filelist:
        print(f)
    
    
    
    
    #print(dictionary["cloned_software_image_name"])
    # for key, value in dictionary.items():
        # print (key + " : " + str(value))