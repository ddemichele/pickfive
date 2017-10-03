<g:if test="${bHome == 'true'}">
<div  class="teamDisplay hometeam">
    ${fieldValue(bean:team, field:'name')}
    <img src="/pickfive/images/nfl/${fieldValue(bean:team, field:'large_img')}.gif" />
</div>
</g:if>
<g:else>
<div class="">
    <img src="/pickfive/images/nfl/${fieldValue(bean:team, field:'large_img')}.gif" />
    ${fieldValue(bean:team, field:'name')}
</div>
</g:else>