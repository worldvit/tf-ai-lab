#!/bin/bash
# 전체 삭제 1단계 (작업용 EC2 브라우저 VS Code 터미널) — Terraform으로 만든 것 모두 삭제
# 사용: cd ~/tf-ai-lab && bash infra/destroy-tf.sh
cd "$(dirname "$0")/.." || exit 1
export AWS_REGION=ap-northeast-2
R=$(git remote get-url origin | sed -E 's#.*github.com[:/]##; s#\.git$##')
for d in live day3/lab day2/envs/dev day2/lab1 day1/lab2 day1/lab1 day2/adv1 day2/adv2; do
  [ -d "$d/.terraform" ] || continue
  n=$(terraform -chdir=$d state list 2>/dev/null | wc -l)
  [ "$n" = 0 ] && continue
  echo "== $d 삭제 ($n개)"
  TF_VAR_db_password=${TF_VAR_db_password:-placeholder-for-destroy} \
    terraform -chdir=$d destroy -auto-approve -input=false -no-color | tail -1
done
if [ -d day4/oidc/.terraform ]; then
  echo "== day4/oidc 삭제"
  terraform -chdir=day4/oidc destroy -auto-approve -input=false -no-color -var github_repo=$R | tail -1
fi
echo "다음: CloudShell에서 2단계 삭제 (상태 버킷 · 작업용 EC2)"
