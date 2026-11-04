# 모듈 만들기 자리

AI에게 모듈을 받을 때는 **입력(variables)·출력(outputs) 약속을 먼저** 주고 main.tf를 요청한다.

| 모듈 | 입력 | 출력 |
|---|---|---|
| network | name, vpc_cidr, az_count(2~3) | vpc_id, public_subnet_ids(map), private_subnet_ids(map) |
| compute | name, vpc_id, subnet_ids(map), instance_type | web_urls(map) |

정답: `day2/solution/modules/`
