<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes" encoding="utf-8" />

  <!-- Racine du document -->
  <xsl:template match="w:document">
    <html>
      <meta http-equiv="Content-Type" content="text/html: charset=UTF-8" />
      <style>
          p{padding:10px;}
          table{margin:20px;border-collapse: collapse;}
          td{border:1px solid darkgrey;}
          span:hover{background:darkred;color:white}
          p:hover{background:lightgreen;}
          ul:hover,ol:hover{background: lightblue;}
      </style>
      <xsl:apply-templates />
    </html>
  </xsl:template>

  <!-- corps du document -->
  <xsl:template match="w:body">
    <body>
      <xsl:apply-templates select="w:tbl" />
    </body>
  </xsl:template>

  <!-- Tableau -->
  <xsl:template match="w:tbl">
    <table>
      <xsl:apply-templates />
    </table>
  </xsl:template>

  <!-- Ligne représentant un attribut d'article -->
  <xsl:template match="w:body/w:tbl/w:tr">
    <tr>
      <xsl:apply-templates select="w:tc" />
    </tr>
  </xsl:template>

  <!-- Ligne de tableau de données -->
  <xsl:template match="w:tr">
    <tr>
      <xsl:apply-templates />
    </tr>
  </xsl:template>

  <!-- Cellule d'un tableau réprésentant un article -->
  <xsl:template match="w:body/w:tbl/w:tr/w:tc">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- Cellule d'un tableau  de données -->
  <xsl:template match="w:tbl/w:tr/w:tc">
    <td>
        <xsl:attribute name="vmerge">
          <xsl:value-of select="count(../following-sibling::w:tr[(w:tc)[6][not(w:tcPr/w:vMerge[@w:val='restart'])]])" />
        </xsl:attribute>
      <xsl:if test="w:tcPr/w:gridSpan">
        <xsl:attribute name="colspan">
          <xsl:value-of select="w:tcPr/w:gridSpan/@w:val" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="w:tcPr/w:vMerge[@w:val='restart']">
        <xsl:attribute name="rowspan">
          <xsl:variable name="position" select="1+count(preceding-sibling::w:tc)" />
          <!-- Les parenthèses autour de w:tc sont importantes pour ne pas compter les w:tcPr -->
          <!-- todo: pas encore parfait -->
          <!--xsl:value-of select="1+count(../../w:tr[(w:tc)[$position][w:tcPr/w:vMerge[@w:val='continue']]])" /-->
          <xsl:value-of select="1+count(../following-sibling::w:tr[(w:tc)[$position][w:tcPr/w:vMerge[@w:val='continue']]])" />
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates />
    </td>
  </xsl:template>

  <xsl:template match="w:tbl/w:tr/w:tc[w:tcPr/w:vMerge[@w:val='continue']]"></xsl:template>

  

  <!-- Paragraphe représentant un item de liste hors d'une liste -->
  <xsl:template match="w:p[node()/w:numPr]"></xsl:template>

  <!-- Paragraphe représentant un item de liste ayant déjà commencé -->
  <xsl:template match="w:p[node()/w:numPr]" mode="embed">
    <li><xsl:apply-templates /></li>
    <xsl:apply-templates select="following-sibling::w:p[1][node()/w:numPr]" mode="embed"/>
  </xsl:template>

  <!-- Paragraphe représentant le premier item d'une liste -->
  <!--xsl:template match="w:p[node()/w:numPr][not(preceding-sibling::w:p[node()/w:numPr])]"-->
  <xsl:template match="w:p[node()/w:numPr][preceding-sibling::*[1][not(node()/w:numPr)]]">
    <ul>
      <li><xsl:apply-templates /></li>
      <xsl:apply-templates select="following-sibling::w:p[1][node()/w:numPr]" mode="embed"/>
    </ul>
  </xsl:template>


  <!-- Paragraphe normal -->
  <xsl:template match="w:p">
    <p><xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="w:r">
    <xsl:apply-templates />
  </xsl:template>

  <!-- Texte gras -->
  <xsl:template match="w:t[preceding-sibling::w:rPr[w:rStyle/@w:val='Accentuationforte']]">
    <strong><xsl:value-of select="." /></strong>
  </xsl:template>

  <xsl:template match="w:t">
    <span><xsl:value-of select="." /></span>
  </xsl:template>


  <!--xsl:template match="w:tc">
    <td><xsl:apply-templates /></td>
  </xsl:template-->

  <!-- Toutes les celulles contenant le body d'un article -->
  <!--xsl:template match="w:body/w:tbl/w:tr/w:tc[preceding-sibling::w:tc[descendant::w:t[text()='Body']]]">
    <section><xsl:apply-templates /></section>
  </xsl:template-->

  <!-- eZXML -->

  


  <!-- rien -->
  <xsl:template match="w:br">
    <br />
  </xsl:template>

  <!-- rien -->
  <xsl:template match="*"></xsl:template>

</xsl:stylesheet>
