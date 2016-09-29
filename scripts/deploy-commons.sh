#! /bin/bash
# Common functions for deploying infrastructure

usage() {
    echo "Usage: $0 [-p /path/to/template] [-t template.j2] [-i inventory.ini]" 1>&2;
    exit 1;
}

# Deploy function that handles common deployment tasks
# Parameters
# -p Path to template directory
# -t template name
# -i inventory jinja2 template
deploy () {
    while getopts ":p:t:i:" o; do
        case "${o}" in
            p)
                path=${OPTARG}
                ;;
            t)
                template=${OPTARG}
                ;;
            i)
                inventory=${OPTARG}
                ;;
            *)
                usage
                ;;
        esac
    done
    shift $((OPTIND-1))

    cd $path ||  { echo "directory ${path} does not exist"; exit 1; }
    # install terrible
    if [ ! -d ".venv" ]; then
        echo "Creating new virtualenv"
        virtualenv .venv ||  { echo "virtualenv failed make sure virtualenv is installed. `pip install virtualenv`"; exit 1; }
    fi
    . .venv/bin/activate
    pip install --upgrade pip || { echo "pip install failed"; exit 1; }
    pip install git+https://github.com/RobotsAndPencils/terrible || { echo "install of terrible failed"; exit 1; }
    pip install ansible || { echo "ansible install failed"; exit 1; }
    # now reactivate to get ansible and terrible
    . .venv/bin/activate
    # Use terrible to transform terrform state into ansible inventory
    if [ ! -f "$path/.terraform/terraform.tfstate" ]; then
        echo "Terrform remote state not found using local state"
        tfstate=terraform.tfstate
    else
        echo "Using remote terraform state"
        tfstate=$path/.terraform/terraform.tfstate
    fi
    terrible --template-path $path \
    --template $template \
    --tfstate $tfstate --inventory-output $inventory || { echo "terrible generation failed"; exit 1; }

    # Wait for hosts to come online so ansible can provision them
    ALL_HOSTS_ALIVE=1
    # disable host checking for ansible
    export ANSIBLE_HOST_KEY_CHECKING=False
    while [  $ALL_HOSTS_ALIVE -gt 0 ]; do
        echo "Ping deployed hosts..."
        sleep 5
        ansible all -m ping --inventory-file=$inventory
        ALL_HOSTS_ALIVE=$?
    done

    echo "Setting ROLES path ${ROOT}/roles"
    export ANSIBLE_ROLES_PATH="${ROOT}/roles"

    echo "Running ansible playbook:
    ansible-playbook playbook-main.yml \
    -i ${INVENTORYFILE} \
    -e user=ubuntu
    "
    ansible-playbook playbook-main.yml \
    -i $inventory \
    -e user=ubuntu
}
