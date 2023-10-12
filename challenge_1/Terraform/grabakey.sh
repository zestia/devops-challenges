#!/bin/zsh
red=$(tput setaf 1)
yellow=$(tput setaf 3)
#Format keys for user
creds=$(cat ~/.aws/sso/cache/$(ls -lt ~/.aws/sso/cache | head -n 2 | tail -n 1 | awk '{print $9}'))
account=$(aws sts get-caller-identity --profile sso)
keys=$(echo $(aws sso get-role-credentials --account-id $(echo $account | jq -r .Account) --role-name $(echo $account | jq -r .Arn | sed 's/_/ /g' | awk '{print $2}') --access-token $(echo $creds | jq -r .accessToken) --region $(echo $creds | jq -r .region) | jq .) | jq -r .roleCredentials)

# Read input if no keys found empty
if [ -z "$keys" ]; then
    echo "It appears we have a fault, Please paste in the lines from option 2 on AWS SSO Screen (press Enter twice when finished)):"
    while read -t 5 line || [[ -n "$line" ]]; do
      if [[ -z "$line" ]]; then
        break
      fi
      keys="$input$line"$'\n'
    done
    # Extract access key, secret key, and session token
    access_key=$(echo "$input" | sed -nE 's/^aws_access_key_id=([^[:space:]]+).*$/access_key="\1/p')
    secret_key=$(echo "$input" | sed -nE 's/^aws_secret_access_key=([^[:space:]]+).*$/secret_key="\1/p')
    token=$(echo "$input" | sed -nE 's/^aws_session_token=([^[:space:]]+).*$/token="\1/p')
    # Print output
    clear
    printf "${red}Please copy and paste these key into the providers .tf file${yellow}"
    echo ""
    echo ${access_key}\"
    echo ${secret_key}\"
    echo ${token}\"
else
    access_key=$(echo "$keys" | jq -r .accessKeyId)
    secret_key=$(echo "$keys" | jq -r .secretAccessKey)
    token=$(echo "$keys" | jq -r .sessionToken)
    # Print output
    clear
    printf "${red}A new providers.tf file has been written with your new keys${yellow}\n\n\n"
    printf 'provider "aws" {
    region     = "eu-west-1" 
    
    access_key = "'${access_key}'"
    secret_key = "'${secret_key}'"
    token = "'${token}'"
    default_tags {
    tags = {
      Category  = "TechTest"
    }
  }
}' > providers.tf
fi
