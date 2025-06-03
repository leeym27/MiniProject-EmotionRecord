# 📝 MiniProject – 감정 기록 iOS 앱


## 📺 시연 영상

[👉 유튜브링크](https://youtu.be/5XZD0PKqw-8)



하루하루의 감정을 이모지와 메모로 간편하게 기록하고,  
📆 **캘린더**와 📊 **통계 차트**를 통해 감정 변화를 한눈에 확인할 수 있는 감정 일지 앱입니다.  
**Firebase Firestore**와 연동하여 로그인/회원가입 및 데이터 동기화를 지원합니다.

---

## 🔑 주요 기능

- ✅ **회원가입 및 로그인**  
  - 학번 + 비밀번호 기반
  - Firebase Firestore에 사용자 정보 저장  
  - 로그인 성공 시 로컬에 `UserDefaults`로 사용자 유지

- 🖊️ **오늘의 감정 기록**  
  - 5가지 이모지 감정 선택  
  - 간단한 메모 작성  
  - Firestore에 자동 저장

- 🔄 **감정 수정 / 삭제**  
  - 이전 기록 수정 및 삭제 가능 (기능 확장 가능)

- 📆 **캘린더 기반 감정 표시**  
  - 날짜별 감정 이모지가 캘린더에 표시됨

- 📊 **월별 감정 통계**  
  - 긍정/부정 비율 (Progress Bar)
  - 이모지별 개수 표시

---

## 🛠 사용 기술

| 기술 | 설명 |
|------|------|
| `Swift` | 주요 개발 언어 |
| `UIKit + Storyboard` | UI 구성 |
| `Firebase Firestore` | 감정 데이터, 사용자 정보 저장 |
| `Git` / `GitHub` | 형상 관리 |
| `.gitignore` | `GoogleService-Info.plist` 보안 제외 처리 |

---

## 📁 디렉토리 구조 (중요 파일)
```
MiniProject/
├── AppDelegate.swift // Firebase 초기 설정
├── SceneDelegate.swift
├── LoginViewController.swift // 로그인 & 회원가입 뷰
├── RecordViewController.swift // 감정 기록 화면
├── CalendarViewController.swift // 캘린더 및 통계
├── Model.swift // MoodEntry 데이터 모델
├── Main.storyboard // 전체 UI 구조
├── Assets.xcassets // 앱 이미지 및 컬러 리소스
├── GoogleService-Info.plist // Firebase 설정 (❗️Git 제외됨)
```


## 📌 주요 코드 설명
### 🔐 LoginViewController.swift
회원가입 + 로그인 기능 구현

UISwitch로 회원가입 여부를 판단

Firestore에 users 컬렉션 생성 및 문서 추가

로그인 시 UserDefaults에 학번 저장

성공 시 TabBarController로 이동

→ 가장 중요한 입구! Firebase 연결과 조건 분기 로직이 핵심임


### 📝 RecordViewController.swift
오늘 날짜에 감정(이모지)과 메모를 기록

선택된 감정을 selectedMood에 저장하고 Firestore에 moodEntries로 저장

수정 모드일 땐 기존 데이터 불러와서 UI 세팅

→ 감정 선택 UI, 유효성 체크, Firestore 업로드 로직 포함

### 📅 CalendarViewController.swift
현재 월 기준으로 달력 셀 구성

날짜에 해당하는 감정 이모지를 매핑해서 보여줌

Firestore에서 데이터를 받아 달력 및 감정 통계 계산

긍정/부정 비율

이모지별 카운트 표시

→ 날짜 계산, 감정 통계, 셀 리사이징 등에서 로직이 복잡함

### 🧠 Model.swift
MoodEntry 구조체 정의

감정 날짜를 Date로 변환하는 dateValue 속성 제공

→ 모든 뷰에서 사용하는 공통 데이터 모델


