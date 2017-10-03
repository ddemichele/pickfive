<tr class="listBgSel">
  <td class="listuser">${selections[0][3]} ${selections[0][4]}<g:if test="${selections[0][1] > 1}"> #${selections[0][2]}</g:if></td>
  <g:each in="${selections}" status="i" var="sel">
          <td class="logo-small logo-nfl-small nfl-small-${sel[5]} game-tooltip <g:if test="${gameResults[sel[9]]==1}">rightpick</g:if><g:if test="${gameResults[sel[9]]==0}">wrongpick</g:if>" title="${games[sel[9]]}" ><span>${sel[9]}</span></td>
  </g:each>
          <td class="logo-small" align="center">
            <img src="/pickfive/images/<g:if test="${selections[0][8] == -1}">red-x.png"</g:if><g:if test="${selections[0][8] == 0}">questionmark.gif" height="23px"</g:if><g:if test="${selections[0][8] == 1}">checkmark.png"</g:if> >
          </td>
          <td class="numbercenter">${selections[0][10]}</td>
</tr>