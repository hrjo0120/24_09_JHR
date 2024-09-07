	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<c:set var="pageTitle" value="${board.code} LIST"></c:set>
	<%@ include file="../common/head.jspf"%>
	<hr />
	
	<section class="mt-24 text-xl px-4">
		<div class="mx-auto">
			<div>${board.name}</div>
			<br />
			<div class="mb-4 flex">
				<div>${faqsCount}개</div>
				<div class="flex-grow"></div>
				<form action="">
					<input type="hidden" name="boardId" value="${param.boardId}" />
					<div class="flex">
						<label class="ml-3 input input-bordered input-sm flex items-center gap-2">
							<input type="text" placeholder="질문을 입력해주세요" name="searchKeyword" value="${param.searchKeyword}" />
							<button type="submit">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="h-4 w-4 opacity-70">
									<path fill-rule="evenodd" d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" clip-rule="evenodd" />
								</svg>
							</button>
						</label>
					</div>
				</form>
			</div>
	
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<thead>
					<tr>
						<th style="text-align: center;">ID</th>
						<th style="text-align: center;">Title</th>
						<th style="text-align: center;">Registration Date</th>
						<th style="text-align: center;">Writer</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="faq" items="${faqs}">
						<tr class="hover" id="faq-${faq.id}">
							<td style="text-align: center;">${faq.id}</td>
							<td style="text-align: center;">
								<a class="hover:underline" href="javascript:void(0);" onclick="loadFaqDetail(${faq.id});">${faq.title}</a>
							</td>
							<td style="text-align: center;">${faq.regDate.substring(0,10)}</td>
							<td style="text-align: center;">${faq.extra__writer}</td>
						</tr>
						<!-- Ajax로 불러온 답변을 표시할 영역 -->
						<tr id="faq-detail-${faq.id}" style="display: none;">
							<td colspan="4" style="text-align: left; padding: 10px;"></td>
						</tr>
					</c:forEach>
	
					<c:if test="${empty faqs}">
						<tr>
							<td colspan="4" style="text-align: center;">궁금한 질문을 검색해주세요</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	
		<!-- 동적 페이징 -->
		<div class="pagination flex justify-center mt-3">
			<c:set var="paginationLen" value="3" />
			<c:set var="startPage" value="${page - paginationLen >= 1 ? page - paginationLen : 1}" />
			<c:set var="endPage" value="${page + paginationLen <= pagesCount ? page + paginationLen : pagesCount}" />
	
			<c:set var="baseUri" value="?boardId=${boardId}" />
			<c:set var="baseUri" value="${baseUri}&searchKeywordTypeCode=${searchKeywordTypeCode}" />
			<c:set var="baseUri" value="${baseUri}&searchKeyword=${searchKeyword}" />
	
			<c:if test="${startPage > 1}">
				<a class="btn btn-sm" href="${baseUri}&page=1">1</a>
			</c:if>
			<c:if test="${startPage > 2}">
				<button class="btn btn-sm btn-disabled">...</button>
			</c:if>
	
			<c:forEach begin="${startPage}" end="${endPage}" var="i">
				<a class="btn btn-sm ${param.page == i ? 'btn-active' : ''}" href="${baseUri}&page=${i}">${i}</a>
			</c:forEach>
	
			<c:if test="${endPage < pagesCount - 1}">
				<button class="btn btn-sm btn-disabled">...</button>
			</c:if>
	
			<c:if test="${endPage < pagesCount}">
				<a class="btn btn-sm" href="${baseUri}&page=${pagesCount}">${pagesCount}</a>
			</c:if>
		</div>
	
		<!-- 직관적인 페이징 -->
		<%-- <div class="pagination flex justify-center mt-3">
			<div class="btn-group">
				<c:forEach begin="1" end="${pagesCount}" var="i">
					<a class="btn btn-sm ${param.page == i ? 'btn-active' : ''}" href="${baseUri}&page=${i}">${i}</a>
				</c:forEach>
			</div>
		</div> --%>
	</section>
	
	<script>
    // AJAX를 통해 FAQ 세부 내용을 불러오기
    function loadFaqDetail(faqId) {
        const detailRow = document.getElementById('faq-detail-' + faqId);

        // 모든 기존 열려 있는 행 닫기
        document.querySelectorAll('tr[id^="faq-detail-"]').forEach(function (row) {
            if (row.id !== 'faq-detail-' + faqId) {
                row.style.display = 'none';  // 숨기기
                row.querySelector('td').innerHTML = '';  // 내용 비우기
            }
        });

        // 이미 열려 있는지 확인
        if (detailRow.style.display === 'table-row') {
            detailRow.style.display = 'none'; // 숨기기
            detailRow.querySelector('td').innerHTML = ''; // 내용 비우기
            return;
        }

        // Ajax 요청
        $.ajax({
            url: '/usr/faq/detail', // FAQ 세부 정보 가져오기 URL (절대 경로로 수정)
            method: 'GET',
            data: { id: faqId },
            success: function(response) {
                console.log('Server response:', response);  // 응답을 콘솔에 출력

                // 응답이 빈 문자열인지 확인하고 올바른지 디버깅
                if (response.trim() === '') {
                    detailRow.querySelector('td').innerHTML = '<div style="text-align: center;">해당 FAQ에 대한 답변이 없습니다.</div>';
                } else {
                    // HTML 응답 데이터를 제대로 처리하여 삽입
                    const responseDiv = document.createElement('div');
                    responseDiv.style.maxWidth = '600px';
                    responseDiv.style.margin = '0 auto';
                    responseDiv.style.textAlign = 'center';
                    responseDiv.innerHTML = response;  // 응답 HTML 삽입

                    detailRow.querySelector('td').innerHTML = '';  // 기존 내용을 지우고
                    detailRow.querySelector('td').appendChild(responseDiv);  // 새로 삽입
                }
                
                detailRow.style.display = 'table-row'; // 보이기

                // 추가 디버깅: 요소에 삽입된 내용 확인
                console.log('Inserted content:', detailRow.querySelector('td').innerHTML);
            },
            error: function(xhr, status, error) {
                console.error('Error: ', error); // 오류 메시지 출력
                alert('FAQ 정보를 불러오는 중 오류가 발생했습니다.');
            }
        });
    }
</script>
	
	<%@ include file="../common/foot.jspf"%>
