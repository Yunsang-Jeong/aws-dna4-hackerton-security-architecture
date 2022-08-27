# aws-dna4-hacsecurity-architecture

- AWS DNA 4기 해커톤 프로젝트 레포입니다.
- AWS 계정에 대한 기본 보안 정책을 수립하고 알람 & 대응 가능한 아키텍쳐 입니다.

<br />

## Concept(Architecture)

다음과 같이 구성됩니다.

- **Pattern(AWS EventBridge)** : AWS EventBridge에서 탐지하고자 하는 패턴

- **Event-handler(AWS Lambda)** : AWS EventBridge에서 탐지한 이벤트를 처리하기 위한 AWS Lambda

  > Pattern과 Event-handler은 1:1로 매칭됩니다.

- **Controller account** : member에서 전송받은 이벤트를 처리합니다.

- **Member accounts** : Pattern 기반으로 감시할 대상 계정이며 controller로 이벤트를 전송합니다.

  > Controller 또한 Member가 될 수 있습니다.

이를 구성하기 위해 `terrafrom` wrapper인 `terragrunt`를 사용하고 있습니다.

<br />

## Configuration

**controller account 또는 member accounmt의 추가 및 수정**

1. `terrgrunt.hcl` 파일 추가

- controller account : `./terragrunt/controller/{ACCOUNT_ALIAS}`에 `terragrunt.hcl` 을 생성합니다.

  - 1. Organization 사전 필수설정

    - AWS Organization(Master account) 콘솔 > Services > CloudTrail `Access enabled` 설정
    - AWS Organization(Master account) 콘솔 > Policies > Service control policies `Enalbed` 설정

  - 2. Chatbot 사전 필수설정

    - AWS Chatbot(Master account) 콘솔에서 slack workspace에 액세스하기 위한 권한을 허용해야 함 (AWS Chatbot > `Configure new client` > 허용)

- member account : `./terragrunt/member/{ACCOUNT_ALIAS}`에 `terragrunt.hcl` 을 생성합니다.


> 설정파일은 기존 파일 참조


**pattern과 event-handler의 추가**

1. `config.yaml` 수정

```yaml
#
# 패턴 별, event-handler 정보와 policy에 대한 정보입니다.
# patterns:
#   {PATTERN_ALIAS}: {POLICY_MAP}
#

patterns:
  console-login:
    source: [aws.signin]
    detail-type: [AWS Console Sign In via CloudTrail]
```

2. event-handler 코드를 `./event-handler-src/{PATTERN_ALIAS}` 경로에 추가합니다.

- 예를 들어, `console-event` 라는 패턴의 event-handler는 `./event-handler/console-event/` 에 위치시킵니다.

3. event-handler가 사용할 lambda function을 비롯한  AWS 리소스를 정의한 terraform module을 `./modules/event-handler/` 경로에 `{PATTERN_ALIAS}`와 동일한 이름으로 추가합니다.

4.  `set-up-controller` 모듈에 해당 모듈을 실행하도록 코드를 추가합니다.

<br />

## How-to-run

**1. terraform, terragrunt 실행파일이 필요합니다.**

```shell
$ brew install terraform terragrunt
```

**2. AWS Credentional을 어떻게 전달할지 결정합니다.**

terraform, terragrunt 런타임 환경의 aws profile 설정을 참조합니다.

**3. 다음과 같이 진행합니다.** 

한 번에 모든 account에 배포하기 위해서는 아래와 같이 진행합니다.

```shell
$ cd terragrunt
$ terragrunt run-all apply
```

특정 account에 대해서 배포하기 위해서는 아래와 같이 진행합니다.

```shell
$ cd terragrunt/controller/vincent
$ terragrunt apply
```
