# AI 검증 훈련 ③ 용 "AI 3계층 초안"

명세를 짧게 줬을 때 AI가 흔히 내놓는 답을 모은 것이다. validate는 통과하지만 결함이 많다.
도구(tflint · Checkov · Trivy)로 결함을 찾고, 결과를 AI에 되먹여 고친다.

```bash
cd ~/tf-ai-lab/day3/lab
for f in ai-draft/*.tf.txt; do cp "$f" "$(basename "${f%.txt}")"; done
```
