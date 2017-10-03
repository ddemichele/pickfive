<div class="slipwrapper">  
<g:each var="i" in="${(0..<user.slips)}">
  <div class="<%if (slipnum==(i+1)){%>slipitem_selected<%}%> slipitem slipwidth">
    <a class="" href="/pickfive/gamePicks?slipnumber=${i+1}">Slip ${i+1}</a>
  </div>
</g:each>
</div>