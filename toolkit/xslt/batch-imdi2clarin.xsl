<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.mpi.nl/IMDI/Schema/IMDI">
<!-- this is a version of imdi2clarin.xsl that batch processes a whole directory structure of imdi files, call it from the command line like this:
        java -jar saxon8.jar -it main batch-imdi2clarin.xsl
        the last template in this file has to be modified to reflect the actual directory name
-->
    <xsl:output method="xml" indent="yes" />
   
    <xsl:template match="METATRANSCRIPT">
        <CMD xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="http://www.clarin.eu/cmd/components/imdi/imdi_md_schema.xsd">
            <Header>
                <Description>
                </Description>
                <Creator>
                </Creator>
                <CreationDate>
                </CreationDate>
                <SelfLink>
                </SelfLink>
                <Profile>
                </Profile>
            </Header>
            <Resources>
                <ResourceProxyList>
                    <xsl:apply-templates select="//Resources" mode="linking"/>
                </ResourceProxyList>
                <JournalFileProxyList>
                </JournalFileProxyList>
                <ResourceRelationList>
                </ResourceRelationList>
            </Resources>
            <Components>       
                <xsl:apply-templates select="Session" />        
            </Components>
        </CMD>
        
    </xsl:template>
    
    <xsl:template match="Resources" mode="linking">
        <xsl:for-each select="MediaFile">
            <ResourceProxy id="{generate-id()}">                
                <ResourceType>Resource</ResourceType>
                <ResourceRef><xsl:value-of select="replace(ResourceLink,'file:/data/corpora','http://corpus1.mpi.nl')"/></ResourceRef>
            </ResourceProxy>
        </xsl:for-each>
        <xsl:for-each select="WrittenResource">
            <ResourceProxy id="{generate-id()}">                
                <ResourceType>Resource</ResourceType>
                <ResourceRef><xsl:value-of select="replace(ResourceLink,'file:/data/corpora','http://corpus1.mpi.nl')"/></ResourceRef>
            </ResourceProxy>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="Session">
        <Session>
            <xsl:apply-templates select="child::Name"/>
            <xsl:apply-templates select="child::Title"/>
            <xsl:apply-templates select="child::Date"/>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>            
            <xsl:apply-templates select="child::MDGroup"/>
            <xsl:apply-templates select="child::Resources" mode="regular"/>
            <xsl:apply-templates select="child::References"/>
        </Session>
    </xsl:template>
    
    <xsl:template match="child::Name">
        <Name>
            <xsl:value-of select="."/>
        </Name>
    </xsl:template>
    
    <xsl:template match="child::Title">
        <Title>
            <xsl:value-of select="."/>
        </Title>
    </xsl:template>
    
    <xsl:template match="child::Date">
        <Date>
            <xsl:value-of select="."/>
        </Date>
    </xsl:template>
    
    <xsl:template match="child::MDGroup">
        <MDGroup>
            <xsl:apply-templates select="child::Location"/>
            <xsl:apply-templates select="child::Project"/>
            <xsl:apply-templates select="child::Keys"/>
            <xsl:apply-templates select="child::Content"/>
            <xsl:apply-templates select="child::Actors"/>            
        </MDGroup>
    </xsl:template>
    
    <xsl:template match="Location">
        <Location>
            <Continent><xsl:value-of select="child::Continent"/></Continent>
            <Country><xsl:value-of select="child::Country"/></Country>
            <xsl:if test="exists(child::Region)">
                <Region><xsl:value-of select="child::Region"/></Region>
            </xsl:if>
            <xsl:if test="exists(child::Address)">
                <Address><xsl:value-of select="child::Address"/></Address>
            </xsl:if>
        </Location>        
    </xsl:template>
    
    <xsl:template match="Project">
        <Project>
            <Name><xsl:value-of select="child::Name"/></Name>
            <Title><xsl:value-of select="child::Title"/></Title>
            <Id><xsl:value-of select="child::Id"/></Id>
            <xsl:apply-templates select="Contact"/>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
        </Project>
    </xsl:template>
    
    <xsl:template match="Contact">
        <Contact>
            <Name><xsl:value-of select="child::Name"/></Name>
            <Address><xsl:value-of select="child::Address"/></Address>
            <Email><xsl:value-of select="child::Email"/></Email>
            <Organisation><xsl:value-of select="child::Organisation"/></Organisation>
        </Contact>        
    </xsl:template>
    
    <xsl:template match="Keys">
        <Keys>
            <xsl:for-each select="Key">
                <Key><xsl:attribute name="Name"><xsl:value-of select="@Name"></xsl:value-of></xsl:attribute><xsl:value-of select="."></xsl:value-of></Key>
            </xsl:for-each>
        </Keys>
    </xsl:template>
    
    <xsl:template match="Content">
        <Content>
            <Genre><xsl:value-of select="child::Genre"/></Genre>
            <xsl:if test="exists(child::SubGenre)">
                <SubGenre><xsl:value-of select="child::SubGenre"/></SubGenre>
            </xsl:if>
            <xsl:if test="exists(child::Task)">
                <Task><xsl:value-of select="child::Task"/></Task>
            </xsl:if>
            <xsl:if test="exists(child::Modalities)">
                <Modalities><xsl:value-of select="child::Modalities"/></Modalities>
            </xsl:if>
            <xsl:if test="exists(child::Subject)">
                <Subject><xsl:value-of select="child::Subject"/></Subject>
            </xsl:if>
            <xsl:apply-templates select="child::CommunicationContext"/>
            <xsl:apply-templates select="child::Languages" mode="content"/>
            <xsl:apply-templates select="child::Keys"/>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
        </Content>
        
    </xsl:template>
    
    <xsl:template match="CommunicationContext">
        <CommunicationContext>
            <xsl:if test="exists(child::Interactivity)">
                <Interactivity><xsl:value-of select="child::Interactivity"/></Interactivity>
            </xsl:if>
            <xsl:if test="exists(child::PlanningType)">
                <PlanningType><xsl:value-of select="child::PlanningType"/></PlanningType>
            </xsl:if>
            <xsl:if test="exists(child::Involvement)">
                <Involvement><xsl:value-of select="child::Involvement"/></Involvement>
            </xsl:if>
            <xsl:if test="exists(child::SocialContext)">
                <SocialContext><xsl:value-of select="child::SocialContext"/></SocialContext>
            </xsl:if>
            <xsl:if test="exists(child::EventStructure)">
                <EventStructure><xsl:value-of select="child::EventStructure"/></EventStructure>
            </xsl:if>
            <xsl:if test="exists(child::Channel)">
                <Channel><xsl:value-of select="child::Channel"/></Channel>
            </xsl:if>
        </CommunicationContext>
    </xsl:template>
    
    <xsl:template match="Languages" mode="content">
        <Content_Languages>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
            <xsl:for-each select="Language">
                <Content_Language>
                    <Id><xsl:value-of select=" ./Id"/></Id>
                    <Name><xsl:value-of select=" ./Name"/></Name>
                    <xsl:if test="exists(child::Dominant)">
                        <Dominant><xsl:value-of select=" ./Dominant"/></Dominant>
                    </xsl:if>
                    <xsl:if test="exists(child::SourceLanguage)">
                        <SourceLanguage><xsl:value-of select=" ./SourceLanguage"/></SourceLanguage>
                    </xsl:if>
                    <xsl:if test="exists(child::TargetLanguage)">
                        <TargetLanguage><xsl:value-of select=" ./TargetLanguage"/></TargetLanguage>
                    </xsl:if>
                    <xsl:if test="exists(child::Description)">
                        <descriptions>
                            <xsl:for-each select="Description">
                                <Description>
                                    <xsl:attribute name="LanguageId" select="@LanguageId"/>
                                    <xsl:value-of select="."/>
                                </Description>
                            </xsl:for-each>
                        </descriptions>                
                    </xsl:if>
                </Content_Language>
            </xsl:for-each>
        </Content_Languages>
    </xsl:template>

    <xsl:template match="Actors">
        <Actors>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
            <xsl:for-each select="Actor">
                <Actor>
                    <Role><xsl:value-of select=" ./Role"/></Role>
                    <Name><xsl:value-of select=" ./Name"/></Name>
                    <FullName><xsl:value-of select=" ./FullName"/></FullName>
                    <Code><xsl:value-of select=" ./Code"/></Code>
                    <FamilySocialRole><xsl:value-of select=" ./FamilySocialRole"/></FamilySocialRole>
                    <EthnicGroup><xsl:value-of select=" ./EthnicGroup"/></EthnicGroup>
                    <Age><xsl:value-of select=" ./Age"/></Age>
                    <BirthDate><xsl:value-of select=" ./BirthDate"/></BirthDate>
                    <Sex><xsl:value-of select=" ./Sex"/></Sex>
                    <Education><xsl:value-of select=" ./Education"/></Education>
                    <Anonymized><xsl:value-of select=" ./Anonymized"/></Anonymized>
                    <xsl:apply-templates select="Contact" />
                    <xsl:apply-templates select="child::Keys"/>
                    <xsl:if test="exists(child::Description)">
                        <descriptions>
                            <xsl:for-each select="Description">
                                <Description>
                                    <xsl:attribute name="LanguageId" select="@LanguageId"/>
                                    <xsl:value-of select="."/>
                                </Description>
                            </xsl:for-each>
                        </descriptions>                
                    </xsl:if>
                    <xsl:apply-templates select="child::Languages" mode="actor" />
                </Actor>
            </xsl:for-each>
        </Actors>
    </xsl:template>

    <xsl:template match="Languages" mode="actor">
        <Actor_Languages>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
            <xsl:for-each select="Language">
                <Actor_Language>
                    <Id><xsl:value-of select=" ./Id"/></Id>
                    <Name><xsl:value-of select=" ./Name"/></Name>
                    <xsl:if test="exists(child::MotherTongue)">
                        <MotherTongue><xsl:value-of select=" ./MotherTongue"/></MotherTongue>
                    </xsl:if>
                    <xsl:if test="exists(child::PrimaryLanguage)">
                        <PrimaryLanguage><xsl:value-of select=" ./PrimaryLanguage"/></PrimaryLanguage>
                    </xsl:if>
                    <xsl:if test="exists(child::Description)">
                        <descriptions>
                            <xsl:for-each select="Description">
                                <Description>
                                    <xsl:attribute name="LanguageId" select="@LanguageId"/>
                                    <xsl:value-of select="."/>
                                </Description>
                            </xsl:for-each>
                        </descriptions>                
                    </xsl:if>
                </Actor_Language>
            </xsl:for-each>            
        </Actor_Languages>
    </xsl:template>
    

    <xsl:template match="child::Resources" mode="regular">
        <Resources>
            <xsl:apply-templates select="MediaFile"/>
            <xsl:apply-templates select="WrittenResource"/>
            <xsl:apply-templates select="Source"/>
            <xsl:apply-templates select="Anonyms"/>            
        </Resources>
    </xsl:template>
    
    <xsl:template match="MediaFile">
        <MediaFile ref="{generate-id()}">
            <ResourceLink><xsl:value-of select=" ./ResourceLink"/></ResourceLink>
            <Type><xsl:value-of select=" ./Type"/></Type>
            <Format><xsl:value-of select=" ./Format"/></Format>
            <Size><xsl:value-of select=" ./Size"/></Size>
            <Quality><xsl:value-of select=" ./Quality"/></Quality>
            <RecordingConditions><xsl:value-of select=" ./RecordingConditions"/></RecordingConditions>
            <TimePosition>
                <Start><xsl:apply-templates select="TimePosition/Start"/></Start>
                <xsl:if test="exists(descendant::End)">
                    <End><xsl:apply-templates select="TimePosition/End"/></End>
                </xsl:if>
            </TimePosition>
            <xsl:apply-templates select="Access"/>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
            <xsl:apply-templates select="child::Keys"/>            
        </MediaFile>        
    </xsl:template>
    
    <xsl:template match="Access">
        <Access>
            <Availability><xsl:value-of select=" ./Availability"/></Availability>
            <Date><xsl:value-of select=" ./Date"/></Date>
            <Owner><xsl:value-of select=" ./Owner"/></Owner>
            <Publisher><xsl:value-of select=" ./Publisher"/></Publisher>
            <xsl:apply-templates select="Contact" />
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
        </Access>
    </xsl:template>
    
    <xsl:template match="WrittenResource">
        <WrittenResource ref="{generate-id()}">
            <ResourceLink><xsl:value-of select=" ./ResourceLink"/></ResourceLink>
            <MediaResourceLink><xsl:value-of select=" ./MediaResourceLink"/></MediaResourceLink>
            <Date><xsl:value-of select=" ./Date"/></Date>
            <Type><xsl:value-of select=" ./Type"/></Type>
            <SubType><xsl:value-of select=" ./SubType"/></SubType>
            <Format><xsl:value-of select=" ./Format"/></Format>            
            <Size><xsl:value-of select=" ./Size"/></Size>
            <Derivation><xsl:value-of select=" ./Derivation"/></Derivation>            
            <CharacterEncoding><xsl:value-of select=" ./CharacterEncoding"/></CharacterEncoding>
            <ContentEncoding><xsl:value-of select=" ./ContentEncoding"/></ContentEncoding>
            <LanguageId><xsl:value-of select=" ./LanguageId"/></LanguageId>
            <Anonymized><xsl:value-of select=" ./Anonymized"/></Anonymized>
            <xsl:apply-templates select="Validation"/>    
            <xsl:apply-templates select="Access"/>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
            <xsl:apply-templates select="Keys"/>        
        </WrittenResource>
    </xsl:template>
    
    <xsl:template match="Validation">
        <Validation>
            <Type><xsl:value-of select=" ./Type"/></Type>
            <Methodology><xsl:value-of select=" ./Methodology"/></Methodology>
            <Level><xsl:value-of select=" ./Level"/></Level>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
        </Validation>
    </xsl:template>
    
    <xsl:template match="Source">
        <Source>
            <Id><xsl:value-of select=" ./Id"/></Id>
            <Format><xsl:value-of select=" ./Format"/></Format>           
            <Quality><xsl:value-of select=" ./Quality"/></Quality>
            <xsl:if test="exists(child::CounterPosition)">
                <CounterPosition>
                    <Start><xsl:apply-templates select="CounterPosition/Start"/></Start>
                    <xsl:if test="exists(descendant::End)">
                        <End><xsl:apply-templates select="CounterPosition/End"/></End>
                    </xsl:if>
                </CounterPosition>
            </xsl:if>
            <xsl:if test="exists(child::TimePosition)">
                <TimePosition>
                    <Start><xsl:apply-templates select="TimePosition/Start"/></Start>
                    <xsl:if test="exists(descendant::End)">
                        <End><xsl:apply-templates select="TimePosition/End"/></End>
                    </xsl:if>
                </TimePosition>
            </xsl:if>
            <xsl:apply-templates select="Access"/>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
            <xsl:apply-templates select="child::Keys"/>
        </Source>
    </xsl:template>
    
    <xsl:template match="Anonyms">
        <Anonyms>
            <ResourceLink><xsl:value-of select=" ./ResourceLink"/></ResourceLink>
            <xsl:apply-templates select="Access"/>
        </Anonyms>
    </xsl:template>
    
    <xsl:template match="child::References">
        <References>
            <xsl:if test="exists(child::Description)">
                <descriptions>
                    <xsl:for-each select="Description">
                        <Description>
                            <xsl:attribute name="LanguageId" select="@LanguageId"/>
                            <xsl:value-of select="."/>
                        </Description>
                    </xsl:for-each>
                </descriptions>                
            </xsl:if>
        </References>
    </xsl:template>
    
    <xsl:template name="main">
        <xsl:for-each select="collection('file:///tmp/alekoe/ma?select=*.imdi;recurse=yes;on-error=ignore')">
            <xsl:result-document href="{document-uri(.)}.cmdi">
                <xsl:apply-templates select="."/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template> 
    
</xsl:stylesheet>
