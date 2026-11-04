# AI 검증 훈련 ② 용 "AI 리팩터링 초안"

AI에게 "변수로 빼고 count를 for_each로 바꿔 줘"라고 했을 때 흔히 받는 답이다.
문법은 맞지만 plan을 보면 서브넷이 **삭제 후 다시 생성**된다. 원인을 찾고 moved 블록으로 고친다.

```bash
cp ai-draft/main.tf ai-draft/variables.tf .
terraform plan | grep -E 'destroy|Plan:'
```
