#!/bin/bash
#
# Script para criação/remoção de usuários no Linux.
# 
#
# USO:
## Adicionar usuário
### ./LinuxUsers.sh -a -b /bin/bash -h /home/username -p senha -u username
## Remover usuário
### ./LinuxUsers.sh -d username


Add(){

while getopts ":b:h:p:u:" Opt
do
	case $Opt in
                b)
                        Bash="$OPTARG"
                ;;
                h)
                        Home="$OPTARG"
                ;;
                p)
                        Password="$OPTARG"
                ;;
		u)
			User="$OPTARG"
		;;
		\?)
			echo "Opção inválida: -$OPTARG"
			exit 1
		;;
		:)
			echo "Opção -$OPTARG necessita argumento."
			exit 1
		;;
	esac
done

while [ ! $Bash ] 
do
	read -p "Informe o shell: " Bash
done

while [ ! $Home ] 
do
	read -p "Informe o home: " Home
done

while [ ! $Password ] 
do
	read -s -p "Informe a senha: " Password
done

while [ ! $User ] 
do
	read -p "Informe o usuario: " User
done

useradd -s "$Bash" -d "$Home" "$User" && {
	echo "Usuário $User criado com sucesso"
	echo "$Password" | passwd --stdin "$User" 
} || {
	echo "Erro criando usuário $User"
}


}

Remove(){

while getopts ":u:" Opt
do
        case $Opt in
                u)
                        User="$OPTARG"
                ;;
                \?)
                        echo "Opção inválida: -$OPTARG"
                        exit 1
                ;;
                :)
                        echo "Opção -$OPTARG necessita argumento."
                        exit 1
                ;;
        esac
done

while [ ! $User ] 
do
        read -p "Informe o usuario: " User
done

userdel -r $User  && {
        echo "Usuário $User removido com sucesso"
} || {  
        echo "Erro removendo usuário $User"
} 

}


while getopts ":ad" Opt
do
	case $Opt in
		a)
			Add $@
		;;
		d)
			Remove $@
		;;
		*)
			echo "Use $0 { -a [ -b shell | -h homedir | -p password | -u usuário ] | -d }"
	esac
done
