<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<div id="">
<table>
    <tbody>
        <tr>
            <td class="candidateSelectionCell"><input id="applicantSelect0" type="radio" name="applicantsRadios"
                                                      value="" <c:if test="${selectedApplicant eq null}"> checked="checked"</c:if>/><span>No Selection</span></td>
        <c:forEach items="${applicants}" var="applicant" varStatus="row">
            <td class="candidateSelectionCell"><input id="applicantSelect${row.count}" type="radio" name="applicantsRadios"
                value="${applicant.id}" <c:if test="${applicant eq selectedApplicant}"> checked="checked"</c:if>/><span>${applicant.name}</span></td>
        <c:if test="${row.last && ((row.count + 1) mod 4) > 0}"><c:forEach var="i" begin="1" end="${4 - ((row.count + 1 )mod 4)}"><td/></c:forEach></c:if>
        <c:if test="${(row.count + 1) mod 4 == 0}"></tr><tr></c:if>
        </c:forEach>
        </tr>
    </tbody>
</table>
</div>
<input type="button" value="Select" id="selectApplicant" class="okDialogButton"/>

