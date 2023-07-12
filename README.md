# Retent
- OpenAI API를 활용하여 PDF를 플래시카드로 만들어주는 Android 기반 어플리케이션입니다.
- PDF 문서 내용을 플래시 카드로 만들어 사용자의 학습을 돕습니다.

## 팀원
  * 유경미
  * 윤인규
 
  
## 개발 환경
- **OS**: Android (minSdk: 19, targetSdk: 31)
- **Language**: Flask
- **IDE**: Visual Studio Code
- **Target Device**: Galaxy S10


## API 명세서
* [api 명세서](https://docs.google.com/spreadsheets/d/1I5m760SvD_AmWcNnrHvrZFp5nZMLsGAL/edit#gid=990061567)
* [swagger](https://70d5-143-248-38-159.ngrok-free.app/swagger/)


## 기능 설명

### 기능 1 : PDF로 플래시카드 만들기
- 사용자가 PDF를 업로드하면 OCR 모듈을 통해 PDF를 Text 파일로 변환합니다.
- 변환한 Text 내용을 기반으로 OpenAI를 활용하여 문제를 만듭니다.

### 기능 2 : 직접 플래시카드 만들기
- 사용자가 직접 문제를 만듭니다.

### 기능 3 : 태그 별로 공유 Deck 조회
- 공유 허용한 Deck들을 태그 별로 조회가 가능합니다.
- 마음에 드는 Deck을 스크랩할 수 있습니다
