###(INIT 시작)
# DB 세팅
DROP DATABASE IF EXISTS `24_08_Spring`;
CREATE DATABASE `24_08_Spring`;
USE `24_08_Spring`;

# 게시글 테이블 생성
CREATE TABLE article(
      id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
      regDate DATETIME NOT NULL,
      updateDate DATETIME NOT NULL,
      title CHAR(100) NOT NULL,
      `body` TEXT NOT NULL
);

# 회원 테이블 생성
CREATE TABLE `member`(
      id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
      regDate DATETIME NOT NULL,
      updateDate DATETIME NOT NULL,
      loginId CHAR(30) NOT NULL,
      loginPw CHAR(100) NOT NULL,
      `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반,7=관리자)',
      `name` CHAR(20) NOT NULL,
      nickname CHAR(20) NOT NULL,
      cellphoneNum CHAR(20) NOT NULL,
      email CHAR(50) NOT NULL,
      delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
      delDate DATETIME COMMENT '탈퇴 날짜'
);



## 게시글 테스트 데이터 생성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목4',
`body` = '내용4';


## 회원 테스트 데이터 생성
## (관리자)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = 'admin',
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자',
cellphoneNum = '01012341234',
email = 'abc@gmail.com';

## (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`name` = '회원1_이름',
nickname = '회원1_닉네임',
cellphoneNum = '01043214321',
email = 'hrjo0120@gmail.com';

## (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = '회원2_이름',
nickname = '회원2_닉네임',
cellphoneNum = '01056785678',
email = 'abcde@gmail.com';

ALTER TABLE article ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER updateDate;

UPDATE article
SET memberId = 2
WHERE id IN (1,2);

UPDATE article
SET memberId = 3
WHERE id IN (3,4);


# 게시판(board) 테이블 생성
CREATE TABLE board (
      id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
      regDate DATETIME NOT NULL,
      updateDate DATETIME NOT NULL,
      `code` CHAR(50) NOT NULL UNIQUE COMMENT 'notice(공지사항) free(자유) QnA(질의응답) ...',
      `name` CHAR(20) NOT NULL UNIQUE COMMENT '게시판 이름',
      delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
      delDate DATETIME COMMENT '삭제 날짜'
);

## 게시판(board) 테스트 데이터 생성
INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'NOTICE',
`name` = '공지사항';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'FREE',
`name` = '자유';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'QnA',
`name` = '질의응답';

INSERT INTO board
SET regDate = NOW(), 
updateDate = NOW(),
`code` = 'FAQ',
`name` = '자주묻는질문';

ALTER TABLE article ADD COLUMN boardId INT(10) UNSIGNED NOT NULL AFTER `memberId`;

UPDATE article
SET boardId = 1
WHERE id IN (1,2);

UPDATE article
SET boardId = 2
WHERE id = 3;

UPDATE article
SET boardId = 3
WHERE id = 4;

ALTER TABLE article ADD COLUMN hitCount INT(10) UNSIGNED NOT NULL DEFAULT 0 AFTER `body`;

# reactionPoint 테이블 생성
CREATE TABLE reactionPoint(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
    relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
    `point` INT(10) NOT NULL
);

# reactionPoint 테스트 데이터 생성
# 1번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 1번 회원이 2번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 2번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 2번 회원이 2번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`point` = -1;

# 3번 회원이 1번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`point` = 1;

# article 테이블에 reactionPoint(좋아요) 관련 컬럼 추가
ALTER TABLE article ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE article ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# update join -> 기존 게시글의 good bad RP 값을 RP 테이블에서 추출해서 article table에 채운다
UPDATE article AS A
INNER JOIN (
    SELECT RP.relTypeCode, Rp.relId,
    SUM(IF(RP.point > 0,RP.point,0)) AS goodReactionPoint,
    SUM(IF(RP.point < 0,RP.point * -1,0)) AS badReactionPoint
    FROM reactionPoint AS RP
    GROUP BY RP.relTypeCode,Rp.relId
) AS RP_SUM
ON A.id = RP_SUM.relId
SET A.goodReactionPoint = RP_SUM.goodReactionPoint,
A.badReactionPoint = RP_SUM.badReactionPoint;

# reply 테이블 생성
CREATE TABLE reply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
    relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
    `body`TEXT NOT NULL
);

# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 1';

# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 2';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 3';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`body` = '댓글 4';

# reply 테이블에 좋아요 관련 컬럼 추가
ALTER TABLE reply ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE reply ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# reactionPoint 테스트 데이터 생성
# 1번 회원이 1번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 1번 회원이 2번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'reply',
relId = 2,
`point` = 1;

# 2번 회원이 1번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 2번 회원이 2번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 2,
`point` = -1;

# 3번 회원이 1번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'reply',
relId = 1,
`point` = 1;

# update join -> 기존 게시물의 good,bad RP 값을 RP 테이블에서 가져온 데이터로 채운다
UPDATE reply AS R
INNER JOIN (
    SELECT RP.relTypeCode,RP.relId,
    SUM(IF(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
    SUM(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
    FROM reactionPoint AS RP
    GROUP BY RP.relTypeCode, RP.relId
) AS RP_SUM
ON R.id = RP_SUM.relId
SET R.goodReactionPoint = RP_SUM.goodReactionPoint,
R.badReactionPoint = RP_SUM.badReactionPoint;

# 파일 테이블 추가
CREATE TABLE genFile (
  id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT, # 번호
  regDate DATETIME DEFAULT NULL, # 작성날짜
  updateDate DATETIME DEFAULT NULL, # 갱신날짜
  delDate DATETIME DEFAULT NULL, # 삭제날짜
  delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0, # 삭제상태(0:미삭제,1:삭제)
  relTypeCode CHAR(50) NOT NULL, # 관련 데이터 타입(article, member)
  relId INT(10) UNSIGNED NOT NULL, # 관련 데이터 번호
  originFileName VARCHAR(100) NOT NULL, # 업로드 당시의 파일이름
  fileExt CHAR(10) NOT NULL, # 확장자
  typeCode CHAR(20) NOT NULL, # 종류코드 (common)
  type2Code CHAR(20) NOT NULL, # 종류2코드 (attatchment)
  fileSize INT(10) UNSIGNED NOT NULL, # 파일의 사이즈
  fileExtTypeCode CHAR(10) NOT NULL, # 파일규격코드(img, video)
  fileExtType2Code CHAR(10) NOT NULL, # 파일규격2코드(jpg, mp4)
  fileNo SMALLINT(2) UNSIGNED NOT NULL, # 파일번호 (1)
  fileDir CHAR(20) NOT NULL, # 파일이 저장되는 폴더명
  PRIMARY KEY (id),
  KEY relId (relTypeCode,relId,typeCode,type2Code,fileNo)
);

# 기존의 회원 비번을 암호화
UPDATE `member`
SET loginPw = SHA2(loginPw,256);


# FAQ 테이블 추가
# 게시글 테이블 생성
CREATE TABLE faq(
	id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	regDate DATETIME NOT NULL,
	updateDate DATETIME NOT NULL,
	memberId INT(10) UNSIGNED NOT NULL,
	boardId INT(10) UNSIGNED NOT NULL,
	title CHAR(100) NOT NULL,
	`body` TEXT NOT NULL
);

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 가입은 어떻게 하나요?', 
`body` = '홈페이지 상단의 "회원가입" 버튼을 클릭하고, 이메일 주소, 비밀번호, 이름 등의 정보를 입력하여 가입 절차를 완료합니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 탈퇴를 원할 때 어떻게 해야 하나요?', 
`body` = '내 정보 페이지에서 "회원 탈퇴" 버튼을 클릭하고 절차에 따라 탈퇴 신청을 완료합니다. 탈퇴 후 모든 정보는 삭제됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '비밀번호를 잊어버렸을 때 어떻게 해야 하나요?', 
`body` = '로그인 페이지에서 "비밀번호 찾기"를 클릭하고 등록된 이메일 주소를 입력하면 비밀번호 재설정 링크가 전송됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '이메일 주소를 변경하려면 어떻게 해야 하나요?', 
`body` = '계정 설정에서 이메일 변경 옵션을 클릭하고 새 이메일 주소를 입력한 후 인증 절차를 완료합니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 정보를 수정하려면 어떻게 해야 하나요?', 
`body` = '로그인 후 "내 정보" 페이지로 이동하여 수정할 정보를 입력하고 저장 버튼을 클릭하면 됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '게시판에 새 글을 작성하는 방법은 무엇인가요?', 
`body` = '게시판 메인 페이지에서 "글쓰기" 버튼을 클릭하고 제목과 내용을 작성한 후 등록 버튼을 누릅니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '게시물을 수정하거나 삭제하려면 어떻게 해야 하나요?', 
`body` = '게시물 하단의 "수정" 또는 "삭제" 버튼을 클릭하여 원하는 작업을 진행합니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '게시판에서 부적절한 게시물을 신고하려면 어떻게 해야 하나요?', 
`body` = '게시물 하단에 있는 "신고" 버튼을 클릭하고 신고 사유를 선택하여 신고할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '로그인이 되지 않을 때 어떻게 해야 하나요?', 
`body` = '아이디와 비밀번호를 다시 확인하고, 문제가 지속되면 고객 센터에 문의해 주세요.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '비밀번호를 안전하게 설정하는 방법은 무엇인가요?', 
`body` = '비밀번호는 8자 이상, 대문자, 소문자, 숫자, 특수문자를 포함하는 것이 좋습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 등급은 어떻게 구분되나요?', 
`body` = '회원 등급은 일반 회원, 실버 회원, 골드 회원 등으로 나뉘며, 활동 점수에 따라 승급됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 혜택은 무엇인가요?', 
`body` = '회원 등급에 따라 할인 쿠폰, 적립금, 무료 배송 등의 혜택이 제공됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '2단계 인증을 설정하려면 어떻게 해야 하나요?', 
`body` = '계정 설정의 보안 섹션에서 2단계 인증을 활성화하고 안내에 따라 설정을 완료합니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 포인트는 어떻게 적립되나요?', 
`body` = '구매, 리뷰 작성, 이벤트 참여 등을 통해 포인트가 적립되며, 쇼핑 시 사용할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원이 되면 어떤 혜택이 있나요?', 
`body` = '회원이 되면 다양한 이벤트 참여와 혜택을 받을 수 있으며, 게시판 사용이 가능합니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '게시물 작성 시 주의사항은 무엇인가요?', 
`body` = '게시물은 타인을 존중하는 내용을 포함해야 하며, 광고나 스팸 게시물은 금지됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '아이디를 변경할 수 있나요?', 
`body` = '아이디는 가입 후 변경이 불가능합니다. 계정을 탈퇴하고 새로 가입해야 합니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 등급에 따른 혜택은 어떻게 받나요?', 
`body` = '회원 등급에 따라 제공되는 혜택은 자동으로 적용되며, 필요한 경우 쿠폰함에서 다운로드할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '이중 로그인을 방지하려면 어떻게 해야 하나요?', 
`body` = '계정 보안 설정에서 2단계 인증을 활성화하고, 비밀번호를 주기적으로 변경하는 것이 좋습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '게시판 이용 시 준수해야 할 규칙은 무엇인가요?', 
`body` = '게시판 이용 시 타인에 대한 비방, 광고, 불법 자료 업로드는 금지되어 있으며, 이를 위반할 시 제재를 받을 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 탈퇴 후 복구가 가능한가요?', 
`body` = '회원 탈퇴 후에는 계정 복구가 불가능하며, 모든 정보가 삭제됩니다. 새로 가입해야 합니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '로그인 세션 시간은 얼마나 되나요?', 
`body` = '보안을 위해 로그인 세션 시간은 30분으로 설정되어 있으며, 이후 자동 로그아웃됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '프로필 사진을 변경하려면 어떻게 해야 하나요?', 
`body` = '내 정보 페이지에서 프로필 사진 변경 옵션을 통해 새로운 이미지를 업로드할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '아이디와 비밀번호를 분실했을 때 어떻게 해야 하나요?', 
`body` = '고객 센터에 문의하여 본인 확인 절차를 거친 후, 아이디 및 비밀번호를 복구할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '계정이 일시 정지된 이유는 무엇인가요?', 
`body` = '계정 일시 정지는 게시판 규칙 위반, 비정상적인 활동 등이 원인일 수 있으며, 고객 센터에 문의해 자세한 사유를 확인할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '게시판에서 댓글을 작성하려면 어떻게 해야 하나요?', 
`body` = '게시물 하단의 댓글 작성란에 내용을 입력하고 "등록" 버튼을 클릭하면 댓글이 게시됩니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '게시판에서 차단된 사용자는 어떻게 해제할 수 있나요?', 
`body` = '게시판 관리자가 해당 사용자의 차단 해제를 결정할 수 있으며, 고객 센터에 문의해 요청할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 전용 이벤트에 참여하려면 어떻게 해야 하나요?', 
`body` = '로그인 후 이벤트 페이지로 이동하여 회원 전용 이벤트에 참여할 수 있습니다.';

INSERT INTO faq SET regDate = NOW(), updateDate = NOW(), memberId = 1, boardId = 4, 
title = '회원 탈퇴 시 남은 포인트는 어떻게 되나요?', 
`body` = '회원 탈퇴 시 남은 포인트는 모두 소멸되며, 복구가 불가능합니다.';


###(INIT 끝)
##########################################
SELECT *
FROM article
ORDER BY id DESC;

SELECT * FROM board;

SELECT * FROM `member`;

SELECT * FROM `reactionPoint`;

SELECT * FROM `reply`;

SELECT * FROM `genFile`;

SELECT * FROM faq;

###############################################################################

SELECT R.*, M.nickname AS extra__writer
			FROM reply AS R
			INNER JOIN `member` AS M
			ON R.memberId = M.id
			WHERE relTypeCode = 'article'
			AND relId = 2
			ORDER BY R.id ASC;

SELECT IFNULL(SUM(RP.point),0)
FROM reactionPoint AS RP
WHERE RP.relTypeCode = 'article'
AND RP.relId = 3
AND RP.memberId = 2


## 게시글 테스트 데이터 대량 생성
INSERT INTO article
(
    regDate, updateDate, memberId, boardId, title, `body`
)
SELECT NOW(), NOW(), FLOOR(RAND() * 2) + 2, FLOOR(RAND() * 3) + 1, CONCAT('제목__', RAND()), CONCAT('내용__', RAND())
FROM article;


SELECT FLOOR(RAND() * 2) + 2

SELECT FLOOR(RAND() * 3) + 1


INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = CONCAT('제목__', RAND()),
`body` = CONCAT('내용__', RAND());

SHOW FULL COLUMNS FROM `member`;
DESC `member`;

SELECT *
FROM article
WHERE boardId = 1
ORDER BY id DESC;

SELECT *
FROM article
WHERE boardId = 2
ORDER BY id DESC;

SELECT *
FROM article
WHERE boardId = 3
ORDER BY id DESC;

'111'

SELECT COUNT(*) AS cnt
FROM article
WHERE boardId = 1
ORDER BY id DESC;

SELECT *
FROM article
WHERE boardId = 1 AND title LIKE '%123%'
ORDER BY id DESC;

SELECT *
FROM article
WHERE boardId = 1 AND `body` LIKE '%123%'
ORDER BY id DESC;

SELECT *
FROM article
WHERE boardId = 1 AND title LIKE '%123%' OR `body` LIKE '%123%'
ORDER BY id DESC;

SELECT COUNT(*)
FROM article AS A
WHERE A.boardId = 1 
ORDER BY A.id DESC;

boardId=1&searchKeywordTypeCode=nickname&searchKeyword=1

SELECT COUNT(*)
FROM article AS A
WHERE A.boardId = 1 AND A.memberId = 3
ORDER BY A.id DESC;

SELECT hitCount
FROM article WHERE id = 3

SELECT * FROM `reactionPoint`;

SELECT A.* , M.nickname AS extra__writer
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
WHERE A.id = 1

# LEFT JOIN
SELECT A.*, M.nickname AS extra__writer, RP.point
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

# 서브쿼리
SELECT A.*, 
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(IF(RP.point > 0,RP.point,0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0,RP.point,0)),0) AS extra__badReactionPoint
FROM (
    SELECT A.*, M.nickname AS extra__writer 
    FROM article AS A
    INNER JOIN `member` AS M
    ON A.memberId = M.id) AS A
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

# JOIN
SELECT A.*, M.nickname AS extra__writer,
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(IF(RP.point > 0,RP.point,0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0,RP.point,0)),0) AS extra__badReactionPoint
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

SELECT IFNULL(SUM(RP.point),0) 
FROM reactionPoint AS RP
WHERE RP.relTypeCode = 'article'
AND RP.relId = 3
AND RP.memberId = 1;

SELECT A.*, M.nickname AS extra__writer, IFNULL(COUNT(R.id),0) AS extra__repliesCount
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN `reply` AS R
ON A.id = R.relId
GROUP BY A.id