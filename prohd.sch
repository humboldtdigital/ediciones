<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2">

    <ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>

    <pattern id="pipeCharacter">
        <rule context="tei:*">
            <report test="text()[contains(., '|')]" role="WARNING"> [W0007] The uncommon character
                '|' has been used within the text area. </report>
        </rule>
    </pattern>
    
  
    <pattern id="allElements">
        <rule context="tei:*[not(self::tei:hi)]">
            <report test="@rendition and @rend" role="WARNING"> [W0001] The usage of @rend or
                @rendition should be exclusionary. </report>
        </rule>
    </pattern>

    <pattern id="allTextNodes">
        <rule context="text()[contains(., '@')]">
            <report test="ancestor::tei:text" role="WARNING"> [W0002] The uncommon character '@' has
                been used within the text area. </report>
        </rule>
    </pattern>

    <pattern id="choiceElement">
        <rule context="tei:choice">
            <assert test="count(*) &gt; 1" role="ERROR"> [E0005] Element " <name/> " must have at least
                two child elements. </assert>
        </rule>
    </pattern>

    <pattern id="choiceSubelements">
        <rule context="tei:corr | tei:abbr | tei:reg | tei:sic | tei:expan">
            <assert test="parent::tei:choice" role="ERROR"> [E0013] Element " <name/> " must have a
                parent element "choice". </assert>
        </rule>
    </pattern>

    <pattern id="corrElement">
        <rule context="tei:corr">
            <assert test="count(preceding-sibling::tei:sic | following-sibling::tei:sic) = 1" role="ERROR"> [E0006] Element " <name/> " must have exactly one corresponding "sic"
                element. </assert>
        </rule>
    </pattern>

    <pattern id="correspAttribute">
        <rule context="tei:*[@corresp]">
            <assert test="matches(@corresp, '^#|^https?://')" role="ERROR"> [E0028] The value of
                attribute @corresp must be a URL or same document reference starting with 'http://'
                or 'https://' or '#'. </assert>
            <assert test="                     if (starts-with(@corresp, '#')) then                         //@xml:id = substring-after(@corresp, '#')                     else                         1" role="error"> [E0026] The value of attribute @corresp must
                have a corresponding @xml:id-value within the same document. </assert>
        </rule>
    </pattern>

    <pattern id="expanElement">
        <rule context="tei:expan">
            <assert test="count(preceding-sibling::tei:abbr | following-sibling::tei:abbr) = 1" role="ERROR"> [E0007] Element " <name/> " must have exactly one corresponding "abbr"
                element. </assert>
        </rule>
    </pattern>

    <!--    <pattern id="facsInsideFirstPagebreak">
        <rule context="tei:pb[1][not(preceding::tei:pb)]">
            <assert test="@facs[matches(., '^#f0001$')]" role="ERROR"> [E0015] Value of @facs within
                first "pb" incorrect; expected value: #f0001. </assert>
        </rule>
    </pattern>-->

    <pattern id="facsInsidePagebreaks">
        <rule context="tei:pb[@facs]">
            <assert test="                     if (matches(@facs, '^#f\d\d\d\d') and matches(preceding::tei:pb[1]/@facs, '^#f\d\d\d\d') and (preceding::tei:pb)) then                         xs:integer(substring(@facs, 3)) = preceding::tei:pb[1]/xs:integer(substring(@facs, 3)) + 1                     else                         1" role="ERROR"> [E0014] Value of @facs within "pb" incorrect;
                @facs-values of "pb"-elements have to increase by 1 continually starting with
                #f0001. </assert>
        </rule>
    </pattern>

    <pattern id="facsOutsidePagebreaks">
        <rule context="tei:*[@facs][not(self::tei:pb)]">
            <assert test="matches(@facs, '^#|^https?://')" role="ERROR"> [E0016] The value of
                attribute @facs must be a URL or same document reference starting with 'http://' or
                'https://' or '#'. </assert>
        </rule>
    </pattern>

    <!--   
    <pattern id="fwHeader">
        <rule context="tei:fw[@type='header']">
            <report test="string(preceding::tei:pb[1]/@facs) = string(following::tei:fw[@type='header'][1]/preceding::tei:pb[1]/@facs)" role="ERROR"> [E0002] Each page may only contain one header. </report>
        </rule>
    </pattern>-->

    <pattern id="hiRendRendition">
        <rule context="tei:hi">
            <report test="(@rendition and @rend) and @rendition != '#none'" role="WARNING"> [W0006]
                The attribute @rend in " <name/> " should be accompanied by an attribute-value-pair
                @rendition="#zero". </report>
        </rule>
    </pattern>

    <pattern id="kValueInRenditionAttribute">
        <rule context="tei:*[@rendition = '#k']">
            <report test="contains(self::tei:*, 'ſ')" role="ERROR"> [E0018] Long s not allowed
                within small capitals area. </report>
        </rule>
    </pattern>

    <!-- <pattern id="metamark">
        <rule context="tei:metamark[@function | @place]">
            <assert test="@function and @place" role="ERROR">
                [E0034] Element "
                <name/>
                " must contain both attributes @function and @place or neither.
            </assert>
        </rule>
    </pattern>-->

    <pattern id="nextAttribute">
        <rule context="tei:*[@next]">
            <assert test="starts-with(@next, '#')" role="ERROR"> [E0017] The value of attribute
                @next must be a same document reference starting with '#'. </assert>
            <assert test="                     if (starts-with(@next, '#')) then                         //@xml:id = substring-after(@next, '#')                     else                         1" role="error"> [E0019] The value of attribute @next must have
                a corresponding @xml:id-value within the same document. </assert>
        </rule>
    </pattern>

    <!--    <pattern id="noteElement">
        <rule context="tei:note">
            <assert test="@type or @place" role="ERROR"> [E0035] Element " <name/> " must contain an
                attribute @place or @type. </assert>
            <report test="preceding::bibl[@type != 'MAN'] and @resp and not(@type = 'editorial')"
                role="ERROR"> [E0036] Element " <name/> " must contain an attribute @place or @type.
            </report>
        </rule>
    </pattern>
-->
    <!--    <pattern id="pbElement">
        <rule context="tei:pb">
            <assert
                test="@facs[matches(., '#f[0-9]{4}')] and @facs[matches(., '^#f0*([1-9][0-9]*)$')]"
                role="ERROR"> [E0008] Wrong format of @facs-value in element " <name/> "; should be
                "#f" followed by 4 digits (0-9) starting with #f0001 and increasing by 1
                continually. </assert>
        </rule>
    </pattern>-->

    <pattern id="prevAttribute">
        <rule context="tei:*[@prev]">
            <assert test="starts-with(@prev, '#')" role="ERROR"> [E0025] The value of attribute
                @prev must be a same document reference starting with '#'. </assert>
            <assert test="                     if (starts-with(@prev, '#')) then                         //@xml:id = substring-after(@prev, '#')                     else                         1" role="error"> [E0021] The value of attribute @prev must have
                a corresponding @xml:id-value within the same document. </assert>
        </rule>
    </pattern>

    <pattern id="regElement">
        <rule context="tei:reg">
            <assert test="count(preceding-sibling::tei:orig | following-sibling::tei:orig) = 1" role="ERROR"> [E0009] Element " <name/> " must have exactly one corresponding "orig"
                element. </assert>
        </rule>
    </pattern>

    <!--  <pattern id="respElement">
        <rule context="tei:resp">
            <assert test="child::tei:*" role="ERROR">
                [E0010] Element "
                <name/>
                " must have at least one child element.
            </assert>
            <report test="child::text()[normalize-space(.)]" role="ERROR"> [E0011] Text not allowed here; expected child element or closing tag. </report>
        </rule>
    </pattern>-->

    <pattern id="salute">
        <rule context="tei:salute">
            <assert test="ancestor::tei:opener | ancestor::tei:closer"> [E0030] The element "salute"
                may only occur within the elements "opener" or "closer". </assert>
        </rule>
    </pattern>

    <!--    <pattern id="sameAsAttribute">
        <rule context="tei:*[@sameAs]">
            <assert test="starts-with(@sameAs, '#')" role="ERROR"> [E0022] The value of attribute
                @sameAs must be a same document reference starting with '#'. </assert>
            <assert
                test="
                    if (starts-with(@sameAs, '#')) then
                        //@xml:id = substring-after(@sameAs, '#')
                    else
                        1"
                role="error"> [E0023] The value of attribute @sameAs must have a corresponding
                @xml:id-value within the same document. </assert>
        </rule>
    </pattern>-->

    <pattern id="sicElement">
        <rule context="tei:sic">
            <assert test="count(preceding-sibling::tei:corr | following-sibling::tei:corr) = 1" role="ERROR"> [E0012] Element " <name/> " must have exactly one corresponding "corr"
                element. </assert>
        </rule>
    </pattern>

    <pattern id="signed">
        <rule context="tei:signed">
            <assert test="ancestor::tei:closer"> [E0029] The element "signed" may only occur within
                the element "closer". </assert>
        </rule>
    </pattern>

    <pattern id="subst">
        <rule context="tei:subst">
            <assert test="child::tei:add and child::tei:del"> [E0037] The element "subst" must
                contain both elements "add" and "del" as child elements. </assert>
        </rule>
    </pattern>

    <pattern id="targetAttribute">
        <rule context="tei:*[@target]">
            <assert test="matches(@target, '^#|^https?://')" role="ERROR"> [E0024] The value of
                attribute @target must be a URL or same document reference starting with 'http://'
                or 'https://' or '#' or '#f'. </assert>
            <assert test="                     if (starts-with(@target, '#') and not(starts-with(@target, '#f'))) then                         //@xml:id = substring-after(@target, '#')                     else                         1" role="error"> [E0032] Value of attribute @target must have a
                corresponding @xml:id-value within the same document.</assert>
            <assert test="                     if (starts-with(@target, '#f')) then                         //tei:pb/@facs = //./@target                     else                         1" role="error"> [E0020] Value of attribute @target must have a
                corresponding @facs-value within a pb element in the same document.</assert>
            <assert test="                     if (. = tei:licence) then                         starts-with(@target, 'https?://')                     else                         1" role="error"> [E0031] Value of attribute @target must have a
                corresponding @facs-value within a pb-element in the same document. </assert>
        </rule>
    </pattern>

    <pattern id="teiHeaderElements">
        <rule context="tei:addName | tei:address | tei:addrLine | tei:email | tei:biblFull | tei:country | tei:forename | tei:genName | tei:msDesc | tei:nameLink | tei:publicationStmt | tei:resp | tei:respStmt | tei:roleName | tei:surname | tei:titleStmt ">
            <report test="ancestor::tei:text" role="ERROR"> [E0001] Element " <name/> " not allowed
                anywhere within element "text". </report>
        </rule>
    </pattern>

    <pattern id="tironianSignEtInText">
        <rule context="text()[contains(., '⁊')]">
            <report test="ancestor::tei:text" role="WARNING"> [W0003] The Unicode character 'U+204A'
                (Tironian sign et) has been used; check, if the source character is 'U+A75B' (Latin
                small letter r rotunda) instead. </report>
        </rule>
    </pattern>


    <pattern id="underbar">
        <rule context="text()[contains(., '_ _')]">
            <report test="ancestor::tei:text" role="WARNING"> [W0008] The string "_ _" has been
                used; check, if this is an adequate transcription of the source. </report>
        </rule>
    </pattern>

    <pattern id="values">
        <rule context="tei:*">
            <report test="@* = ''" role="WARNING"> [W0005] Attribute values may not be the empty
                string. </report>
        </rule>
    </pattern>

    <!-- ProHD additions -->

    <pattern id="titleStmt">
        <rule context="tei:titleStmt">
            <assert test="tei:editor" role="ERROR">A &lt;titleStmt&gt; element must contain an
                &lt;editor&gt; element after &lt;title&gt; .</assert>
            <report test="tei:choice" role="ERROR">A &lt;titleStmt&gt; element cannot contain a
                &lt;choice&gt; element as a children.</report>
            <assert test="tei:funder" role="ERROR">A &lt;titleStmt&gt; element must contain a
                &lt;funder&gt; element after &lt;editor&gt;.</assert>
        </rule>
    </pattern>

    <pattern id="title">
        <rule context="tei:titleStmt/tei:title">
            <report test="child::tei:note | tei:p | tei:choice | tei:lb" role="ERROR">The main title
                of the edition should be normalized and cannot contain notes, alternative readings
                or break lines.</report>
        </rule>
    </pattern>


    <pattern id="editionStmt">
        <rule context="tei:editionStmt">
            <assert test="tei:p" role="ERROR">The information about the edition should be
                represented with a &lt;p&gt;.</assert>
        </rule>
        <rule context="tei:editionStmt/tei:p">
            <report test="child::tei:note | tei:p | tei:choice | tei:lb" role="ERROR">The edition
                statement should be normalized and cannot contain notes, alternative readings or
                break lines.</report>
            <assert test="tei:date[starts-with(., '20')]" role="ERROR">The edition statement should
                contain a &lt;date&gt; (publication date, no creation date).</assert>
        </rule>
    </pattern>


    <pattern id="publicationStmt">
        <rule context="tei:publicationStmt">
            <assert test="tei:publisher" role="ERROR">A &lt;publicationStmt&gt; element must contain
                an &lt;publisher&gt; element.</assert>
            <assert test="tei:availability" role="ERROR">A &lt;publicationStmt&gt; element must
                contain an &lt;availability&gt; element after &lt;pubPlace&gt;.</assert>
        </rule>
    </pattern>

    <pattern id="publisher">
        <rule context="tei:publisher">
            <assert test="tei:ref or text()" role="ERROR">A &lt;publisher&gt; element must contain a
                &lt;ref&gt; element or a text node with the name of the institution publishing the digital edition.</assert>
        </rule>
    </pattern>

    <pattern id="profileDesc">
        <rule context="tei:profileDesc">
            <assert test="tei:langUsage/tei:language" role="ERROR">An edition must contain
                information about the language of the text in &lt;language&gt; inside
                &lt;langUsage&gt;.</assert>
            <report test="tei:creation/tei:persName[not(matches(., '(.+),(.+)'))]" role="ERROR">Incorrect format. The surname should go first and be separated by a coma.</report>
            <report test="tei:correspDesc/correspAction/tei:persName[not(matches(., '(.+),(.+)'))]" role="ERROR">Incorrect format. The surname should go first and be separated by a
                coma.</report>
        </rule>
    </pattern>

    <pattern id="date">
        <rule context="tei:date">
            <report test="@notBefore-iso or @notAfter-iso" role="error">The attributes @notBefore-iso or @notAfter-iso are not allowed.</report>
        </rule>
    </pattern>
    
    <pattern id="idno">
        <rule context="tei:idno">
            <report test="text()[matches(., '\?+$')]" role="WARNING"> [W0007] The uncommon character
                '??' has been used within the text area. If you are not sure about the content, leave the element empty.</report>
        </rule>
    </pattern>
    
    <pattern id="abstract">
        <rule context="tei:abstract">
            <assert test="@xml:lang" role="WARNING">The attribute @xml:lang is compulsory.</assert>
        </rule>
    </pattern>

    <pattern id="language">
        <rule context="tei:language">
            <assert test="@ident" role="WARNING">The attribute @ident is compulsory.</assert>
        </rule>
    </pattern>
    

</schema>