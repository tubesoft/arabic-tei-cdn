<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="3.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns="http://www.w3.org/1999/xhtml"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:variable name="title" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msPart/tei:msContents/tei:msItem/tei:title[@xml:lang='lat-ar']"/>
	<xsl:variable name="author" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msPart/tei:msContents/tei:msItem/tei:author[@xml:lang='lat-ar']"/>

	<!-- Entire Structure -->
	<xsl:template match="/tei:TEI">
		<xsl:element name="v-container">
			<xsl:element name="h1">
				<xsl:value-of select="$title"/>
			</xsl:element>
			<xsl:element name="h3">
				<xsl:attribute name="class">mb-10</xsl:attribute>
				<xsl:value-of select="$author"/>
			</xsl:element>
			<xsl:apply-templates select="tei:teiHeader"/>
			<xsl:element name="bdi">
				<xsl:element name="div">
					<xsl:attribute name="class">text-justify text-h4 double-space</xsl:attribute>
					<xsl:apply-templates select="tei:text/tei:body/tei:div[@xml:lang='ar']"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- Header -->
	<xsl:template match="tei:teiHeader">
		<xsl:element name="div">
			<xsl:attribute name="class">ml-16 mr-16</xsl:attribute>
			<xsl:element name="h3">Sources</xsl:element>
			<xsl:element name="v-expansion-panels">
				<xsl:attribute name="multiple"/>
				<xsl:attribute name="class">mb-10</xsl:attribute>
				<xsl:for-each select="tei:fileDesc/tei:sourceDesc/tei:msDesc">
					<xsl:element name="v-expansion-panel">
						<xsl:element name="v-expansion-panel-header">
							<xsl:attribute name="class">text-h5</xsl:attribute>
							<xsl:value-of select="concat(@xml:id, ' - ' ,tei:msIdentifier/tei:collection, ' ', tei:msIdentifier/tei:idno)"/>
						</xsl:element>
						<xsl:element name="v-expansion-panel-content">
							<xsl:value-of select="concat(tei:msIdentifier/tei:repository, ', ', tei:msIdentifier/tei:settlement, ', ', tei:msIdentifier/tei:country)"/>
							<br/>
							<xsl:value-of select="tei:msPart/tei:msIdentifier/tei:idno"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- Body -->
	<xsl:template match="tei:text/tei:body/tei:div[@xml:lang='ar']">
		<!-- 1st row: not rendering, 2nd: row render as it is, 3rd: render with special processes -->
		<xsl:apply-templates select="tei:fw |

			tei:bibl | tei:orgName | tei:term | tei:persName |

			tei:lb | tei:milestone | tei:p | tei:choice | tei:note |
			tei:unclear | tei:gap | tei:hi | tei:note[@place] |
			tei:seg[@subtype] | tei:note[@type='editorial'] | tei:note[@type='editorial'][@next] |
			tei:del
			"/>
	</xsl:template>

	<!--get any kinds of nodes that is xml:id attribute-->
	<xsl:key name="get-id-node" match="*[@xml:id]" use="concat('#', @xml:id)"/>
	<xsl:key name="get-corresp-node" match="*[@corresp]" use="substring-after(@corresp, '#')"/>
	<xsl:key name="get-additional-note" match="tei:note[@next]" use="substring-after(@next, '#')"/>
	<xsl:key name="get-connected-word-front" match="tei:w[@prev]" use="substring-after(@prev, '#')"/>
	<xsl:key name="get-connected-word-back" match="tei:w[@next]" use="substring-after(@next, '#')"/>

	<!-- Not rendering -->
	<xsl:template match="tei:fw"/>
	<xsl:template match="tei:note[@type='biblio']"/><!-- To surpress in the main text  -->
	<xsl:template match="tei:note[@type='editorial-combined']"/>
	<xsl:template match="tei:w[@next]"/>
	<xsl:template match="tei:w[@prev]"/>

	<!-- Rendering with special processes -->
	<xsl:template match="tei:lb">
		<xsl:if test="count(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc)=1">
			<xsl:if test="not(@break='no')">
				<br/>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:milestone">
		<xsl:element name="bdi">
			<xsl:choose>
			  <xsl:when test="contains(@n, 'line')">
					<xsl:element name="span">
						<xsl:attribute name="class">pa-4 text-body-2 secondary lighten-3 rounded-pill</xsl:attribute>
						<xsl:value-of select="@n"/>
					</xsl:element>
				</xsl:when>
			  <xsl:otherwise>
					<xsl:element name="span">
						<xsl:attribute name="class">pa-4 text-body-2 secondary lighten-3 rounded-pill</xsl:attribute>
						<xsl:value-of select="@n"/>
					</xsl:element>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:p">
		<xsl:choose>
			<xsl:when test="@n='beginning'">
				<xsl:element name="p">
					<xsl:apply-templates/><br/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="p">
					<xsl:attribute name="class">first-line-indent</xsl:attribute>
					<xsl:apply-templates/><br/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Choice element should be used just for quasi-facimille edition -->
	<!-- In a quasi-critical edition, use <app> with <lem> and <rdg> -->
	<xsl:template match="tei:choice">
		<xsl:element name="v-menu">
			<xsl:attribute name="id">v-menu-config</xsl:attribute>
			<xsl:attribute name="offset-y"/>
			<xsl:attribute name="top"/>
			<xsl:attribute name="open-on-hover"/>
			<xsl:element name="template">
				<xsl:attribute name="id">vslot</xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="v-bind">attrs</xsl:attribute>
					<xsl:attribute name="v-on">on</xsl:attribute>
					<xsl:choose>
						<xsl:when test="tei:sic">
							<xsl:choose>
								<xsl:when test="tei:corr[@corresp]">
									<xsl:attribute name="class">warning--text text--lighten-1</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">error--text text--lighten-2</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">success--text text--base</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="tei:corr[@corresp]">
							<xsl:apply-templates select="key('get-id-node', tei:corr/@corresp)" mode="insertion"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="tei:reg | tei:corr"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@xml:id">
						<xsl:variable name="note-id" select="@xml:id"/>
						<sup class="text-subtitle-1">
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>
						</sup>
					</xsl:if>
					<xsl:if test="@synch">
					  <xsl:variable name="note-id" select="@synch"/>
						<sup class="text-subtitle-1">
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>
						</sup>
					</xsl:if>
				</xsl:element>
			</xsl:element>
			<xsl:element name="v-card">
				<xsl:attribute name="outlined"/>
				<xsl:attribute name="shaped"/>
				<xsl:attribute name="max-width">350</xsl:attribute>
				<xsl:if test="./tei:sic"> <!-- When sic is used, make sure add id -->
					<xsl:element name="v-card-subtitle">
						<xsl:variable name="note-id" select="./@xml:id"/>
						Note
						<xsl:value-of select="number(substring-after($note-id, '-'))"/>:
					</xsl:element>
				</xsl:if>
				<xsl:element name="v-card-text">
					<xsl:choose>
					  <xsl:when test="tei:sic and string-length(tei:sic)=0"></xsl:when>
					  <xsl:otherwise>
							In the manuscript,<br/>
							<xsl:element name="span">
								<xsl:attribute name="class">text-h5</xsl:attribute>
								<xsl:element name="bdi">
									<xsl:element name="div">
										<xsl:apply-templates select="tei:orig | tei:sic"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="./tei:corr[@corresp]">
						<br/>
						The correction is suggested
						<xsl:variable name="note-place" select="substring-after(./tei:corr/@corresp,'corr-')"/>
						<xsl:variable name="note-place-number" select="string-length($note-place)"/>
						<xsl:variable name="note-place-trimmed" select="substring($note-place,1,$note-place-number - 3)"/>
						<xsl:value-of select="translate($note-place-trimmed,'-',' ')"/>.
					</xsl:if>
					<xsl:if test="key('get-additional-note', @xml:id)">
						<br/><br/>
						<xsl:value-of select="key('get-additional-note', @xml:id)"/>
					</xsl:if>
					<xsl:if test="@synch">
						<xsl:variable name="note-id" select="@synch"/>
						Note
						<xsl:value-of select="number(substring-after($note-id, '-'))"/>:
						<xsl:value-of select="key('get-id-node', @synch)"/>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:bibl">
		<xsl:element name="v-menu">
			<xsl:attribute name="id">v-menu-config</xsl:attribute>
			<xsl:attribute name="offset-y"/>
			<xsl:attribute name="open-on-hover"/>
			<xsl:element name="template">
				<xsl:attribute name="id">vslot</xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="v-bind">attrs</xsl:attribute>
					<xsl:attribute name="v-on">on</xsl:attribute>
					<xsl:attribute name="class">pa-1 ms-2 warning lighten-4 secondary--text text--base rounded-lg</xsl:attribute>
					<xsl:apply-templates/>
					<xsl:apply-templates select="tei:note[@type='biblio']"/>
					<xsl:if test="./tei:note[@type='biblio']">
						<xsl:variable name="note-id" select="./tei:note/@xml:id"/>
						<sup class="text-subtitle-1">
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>
						</sup>
					</xsl:if>
				</xsl:element>
			</xsl:element>
			<xsl:element name="v-card">
				<xsl:attribute name="outlined"/>
				<xsl:attribute name="shaped"/>
				<xsl:attribute name="max-width">350</xsl:attribute>
				<xsl:element name="v-card-subtitle">
					<xsl:choose>
			      <xsl:when test="./tei:note[@type='biblio']">
							<xsl:variable name="note-id" select="./tei:note/@xml:id"/>
							Note:
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>
						</xsl:when>
			      <xsl:otherwise></xsl:otherwise>
			    </xsl:choose>
				</xsl:element>
				<xsl:element name="v-card-text">
					<xsl:choose>
			      <xsl:when test="./tei:note[@type='biblio']">
							<xsl:value-of select="./tei:note[@type='biblio']"/>
						</xsl:when>
			      <xsl:otherwise>
							NO INFO
						</xsl:otherwise>
			    </xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:element name="v-menu">
			<xsl:attribute name="id">v-menu-config</xsl:attribute>
			<xsl:attribute name="offset-y"/>
			<xsl:attribute name="top"/>
			<xsl:attribute name="open-on-hover"/>
			<xsl:element name="template">
				<xsl:attribute name="id">vslot</xsl:attribute>
				<xsl:element name="span">
					<xsl:element name="bdi">
						<xsl:attribute name="v-bind">attrs</xsl:attribute>
						<xsl:attribute name="v-on">on</xsl:attribute>
						<xsl:attribute name="class">ms-2 accent--text text--darken-1</xsl:attribute>
						<xsl:apply-templates/>
						<xsl:variable name="note-id" select="./@xml:id"/>
						<sup class="text-subtitle-1">
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>
						</sup>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="v-card">
				<xsl:attribute name="outlined"/>
				<xsl:attribute name="shaped"/>
				<xsl:attribute name="max-width">350</xsl:attribute>
				<xsl:element name="v-card-subtitle">
					Note
					<xsl:variable name="note-id" select="./@xml:id"/>
					<xsl:value-of select="number(substring-after($note-id, '-'))"/>:
				</xsl:element>
				<xsl:element name="v-card-text">
					<xsl:element name="span">
						Unclear. <br/>
						Reason:
						<xsl:value-of select="translate(./@reason,'-',' ')"/>.
						<xsl:if test="key('get-additional-note', @xml:id)">
							<br/><br/>
							<xsl:value-of select="key('get-additional-note', @xml:id)"/>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:element>

		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:element name="v-menu">
			<xsl:attribute name="id">v-menu-config</xsl:attribute>
			<xsl:attribute name="offset-y"/>
			<xsl:attribute name="top"/>
			<xsl:attribute name="open-on-hover"/>
			<xsl:element name="template">
				<xsl:attribute name="id">vslot</xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="v-bind">attrs</xsl:attribute>
					<xsl:attribute name="v-on">on</xsl:attribute>
					<xsl:attribute name="class">pa-2 text-body-1 accent lighten-1 secondary--text text--base rounded-pill</xsl:attribute>
					<xsl:variable name="note-id" select="./@xml:id"/>
					<xsl:element name="bdi">
						<sup class="text-subtitle-1">
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>
						</sup>
						Illeg:
						<xsl:choose>
							<xsl:when test="./@quantity">
								<xsl:value-of select="concat(./@quantity, 'w')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(./@atLeast, '-', ./@atMost, 'w')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="v-card">
				<xsl:attribute name="outlined"/>
				<xsl:attribute name="shaped"/>
				<xsl:attribute name="max-width">350</xsl:attribute>
				<xsl:element name="v-card-subtitle">
					Note
					<xsl:variable name="note-id" select="./@xml:id"/>
					<xsl:value-of select="number(substring-after($note-id, '-'))"/>:
				</xsl:element>
				<xsl:element name="v-card-text">
					Illegible
					<br/>
					Reason:
					<xsl:value-of select="translate(./@reason,'-',' ')"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:hi">
		<xsl:choose>
		  <xsl:when test="@rend='overline'">
				<xsl:element name="span">
					<xsl:attribute name="class">text-decoration-overline</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@rend='marked'">
				<xsl:element name="span">
					<xsl:attribute name="class">marked-phrase</xsl:attribute>
					<xsl:apply-templates select="./*[not(self::tei:metamark)]"/>
					<xsl:element name="span">
						<xsl:choose>
						  <xsl:when test="contains(tei:metamark/@place, 'below')">
								<xsl:attribute name="class">text-h6</xsl:attribute>
								<xsl:attribute name="style">
									position: absolute;
									top: 2em;
									left: <xsl:value-of select="number(substring-after(tei:metamark/@place, '-')) div 2"/>em;
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="contains(tei:metamark/@place, 'above')">
								<xsl:attribute name="class">mark-above text-h6</xsl:attribute>
								<xsl:attribute name="style">
									position: absolute;
						      top: -1em;
						      left: <xsl:value-of select="number(substring-after(tei:metamark/@place, '-')) div 2"/>em;
								</xsl:attribute>
							</xsl:when>
						  <xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="tei:metamark"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
		  <xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note[@place]">
		<xsl:element name="v-menu">
			<xsl:attribute name="id">v-menu-config</xsl:attribute>
			<xsl:attribute name="offset-y"/>
			<xsl:attribute name="open-on-hover"/>
			<xsl:element name="template">
				<xsl:attribute name="id">vslot</xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="v-bind">attrs</xsl:attribute>
					<xsl:attribute name="v-on">on</xsl:attribute>
					<xsl:attribute name="class">pa-3 ms-2 text-body-1 warning lighten-1 secondary--text text--base rounded-pill</xsl:attribute>
					<xsl:element name="bdi">
						<xsl:choose>
						  <xsl:when test="contains(@place, 'margin')">
								mg.
							</xsl:when>
							<xsl:when test="@place = 'below'">↓</xsl:when>
							<xsl:when test="@place = 'above'">↑</xsl:when>
						  <xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="v-card">
				<xsl:attribute name="outlined"/>
				<xsl:attribute name="shaped"/>
				<xsl:attribute name="max-width">350</xsl:attribute>
				<xsl:element name="v-card-subtitle">
					<xsl:choose>
					  <xsl:when test="@place='left margin'">In left margin:</xsl:when>
						<xsl:when test="@place='right margin'">In right margin:</xsl:when>
						<xsl:when test="@place='below'">Below line:</xsl:when>
						<xsl:when test="@place='above'">Above line:</xsl:when>
					  <xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="v-card-text">
					<xsl:element name="span">
						<xsl:attribute name="class">text-h5</xsl:attribute>
						<xsl:element name="bdi">
							<xsl:element name="div">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="span">
						<xsl:choose>
						  <xsl:when test="@corresp"> <!--when it is not insertion-->
								<br/>
								See also Note
								<xsl:variable name="note-id" select="@corresp"/>
								<xsl:value-of select="number(substring-after($note-id, '-'))"/>
								in the same line
							</xsl:when>
							<xsl:when test="./tei:seg/tei:seg[@corresp]"> <!--when it is insertion-->
								<br/>
								See also Note
								<xsl:variable name="note-id" select="./tei:seg/tei:seg/@corresp"/>
								<xsl:value-of select="number(substring-after($note-id, '-'))"/>
								in the same line
							</xsl:when>
						  <xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:seg[@subtype]">
		<xsl:element name="v-tooltip">
			<xsl:attribute name="left"/>
			<xsl:attribute name="color">primary</xsl:attribute>
			<xsl:element name="template">
				<xsl:attribute name="id">vslot</xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="v-bind">attrs</xsl:attribute>
					<xsl:attribute name="v-on">on</xsl:attribute>
					<xsl:attribute name="class">warning--text text--darken-1</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="span">
				<xsl:element name="v-icon">
					<xsl:attribute name="small"/>
					mdi-information-outline
				</xsl:element>
				This indicates a
				<xsl:value-of select="translate(./@subtype,'-',' ')"/><br/>
				by the writer of the note
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tei:w[@style]" mode="insertion">
		<xsl:variable name="front" select="key('get-connected-word-front', ../@xml:id)"/>
		<xsl:variable name="main" select="."/>
		<xsl:variable name="back" select="key('get-connected-word-back', ../@xml:id)"/>
		<xsl:choose>
			<xsl:when test="substring-after(@style, '-')='fb'">
				<xsl:value-of select="concat($front,$main,$back)"/>
			</xsl:when>
			<xsl:when test="substring-after(@style, '-')='f'">
				<xsl:value-of select="concat($front,$main)"/>
			</xsl:when>
			<xsl:when test="substring-after(@style, '-')='b'">
				<xsl:value-of select="concat($main,$back)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$main"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:choice" mode="insertion">
		<xsl:variable name="front" select="key('get-connected-word-front', ../@xml:id)"/>
		<xsl:variable name="main" select="tei:reg | tei:corr"/>
		<xsl:variable name="back" select="key('get-connected-word-back', ../@xml:id)"/>
		<xsl:choose>
		  <xsl:when test="substring-after(@style, '-')='fb'">
				<xsl:value-of select="concat($front,$main,$back)"/>
			</xsl:when>
			<xsl:when test="substring-after(@style, '-')='f'">
				<xsl:value-of select="concat($front,$main)"/>
			</xsl:when>
			<xsl:when test="substring-after(@style, '-')='b'">
				<xsl:value-of select="concat($main,$back)"/>
			</xsl:when>
		  <xsl:otherwise>
				<xsl:value-of select="$main"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note[@type='editorial-independent'][@xml:id]">
		<xsl:if test="not(@next)">
			<xsl:element name="v-menu">
				<xsl:attribute name="id">v-menu-config</xsl:attribute>
				<xsl:attribute name="offset-y"/>
				<xsl:attribute name="open-on-hover"/>
				<xsl:element name="template">
					<xsl:attribute name="id">vslot</xsl:attribute>
					<xsl:element name="v-icon">
						<xsl:attribute name="v-bind">attrs</xsl:attribute>
						<xsl:attribute name="v-on">on</xsl:attribute>
						mdi-note-text-outline
						<xsl:variable name="note-id" select="./@xml:id"/>
						<sup class="text-subtitle-1 me-2">
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>
						</sup>
					</xsl:element>
				</xsl:element>
				<xsl:element name="v-card">
					<xsl:attribute name="outlined"/>
					<xsl:attribute name="shaped"/>
					<xsl:attribute name="max-width">350</xsl:attribute>
					<xsl:element name="v-card-subtitle">
						<xsl:variable name="note-id" select="./@xml:id"/>
						Note
						<xsl:value-of select="number(substring-after($note-id, '-'))"/>:
					</xsl:element>
					<xsl:element name="v-card-text">
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:choose>
		  <xsl:when test="@xml:id">
				<xsl:element name="v-menu">
					<xsl:attribute name="id">v-menu-config</xsl:attribute>
					<xsl:attribute name="offset-y"/>
					<xsl:attribute name="top"/>
					<xsl:attribute name="open-on-hover"/>
					<xsl:element name="template">
						<xsl:attribute name="id">vslot</xsl:attribute>
						<xsl:element name="span">
							<xsl:attribute name="v-bind">attrs</xsl:attribute>
							<xsl:attribute name="v-on">on</xsl:attribute>
							<xsl:attribute name="class">warning--text text--lighten-1</xsl:attribute>
							<xsl:variable name="note-id" select="@xml:id"/>
							<xsl:choose>
							  <xsl:when test="@place='above'">
									<sup>
										<xsl:apply-templates/>
										<xsl:if test="@corresp">
											<xsl:value-of select="key('get-corresp-node', @xml:id)"/>
										</xsl:if>
										<span class="text-subtitle-1 me-2">
											<xsl:value-of select="number(substring-after($note-id, '-'))"/>
										</span>
									</sup>
								</xsl:when>
								<xsl:when test="@place='below'">
									<sub>
										<xsl:apply-templates/>
										<xsl:if test="@corresp">
											<xsl:value-of select="key('get-corresp-node', @xml:id)"/>
										</xsl:if>
										<xsl:value-of select="number(substring-after($note-id, '-'))"/>
									</sub>
								</xsl:when>
							  <xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:element>
					<xsl:element name="v-card">
						<xsl:attribute name="outlined"/>
						<xsl:attribute name="shaped"/>
						<xsl:attribute name="max-width">350</xsl:attribute>
						<xsl:element name="v-card-subtitle">
							<xsl:variable name="note-id" select="./@xml:id"/>
							Note
							<xsl:value-of select="number(substring-after($note-id, '-'))"/>:
						</xsl:element>
						<xsl:element name="v-card-text">
							<xsl:choose>
							  <xsl:when test="@corresp">
									In
									<xsl:variable name="note-place" select="substring-after(@corresp,'corr-')"/>
									<xsl:variable name="note-place-number" select="string-length($note-place)"/>
									<xsl:variable name="note-place-trimmed" select="substring($note-place,1,$note-place-number - 3)"/>
									<xsl:value-of select="translate($note-place-trimmed,'-',' ')"/>,
									insertion is suggested
								</xsl:when>
							  <xsl:otherwise>
									This refers to the note in
									<xsl:variable name="margin-place"><xsl:value-of select="key('get-corresp-node', @xml:id)/@place"/></xsl:variable>
									<xsl:value-of select="$margin-place"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="key('get-additional-note', @xml:id)">
								<br/><br/>
								<xsl:value-of select="key('get-additional-note', @xml:id)"/>
							</xsl:if>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:when>
		  <xsl:otherwise>
				<xsl:choose>
				  <xsl:when test="@place='above'">
						<sup><xsl:apply-templates/></sup>
					</xsl:when>
					<xsl:when test="@place='below'">
						<sub><xsl:apply-templates/></sub>
					</xsl:when>
				  <xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
			</xsl:template>

	<xsl:template match="tei:del">
		<xsl:element name="span">
			<xsl:attribute name="class">text-decoration-line-through</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
