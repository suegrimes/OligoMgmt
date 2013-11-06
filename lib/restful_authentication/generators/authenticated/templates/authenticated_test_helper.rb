



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <title>generators/authenticated/templates/authenticated_test_helper.rb at 61cd9b377c0b481384f123dc628a2f8cc5ea5fdf from technoweenie's restful-authentication - GitHub</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="http://github.com/fluidicon.png" title="GitHub" />

    
      <link href="http://assets0.github.com/stylesheets/bundle.css?ae1e63835de171f1051825d37b863d72c8da7805" media="screen" rel="stylesheet" type="text/css" />
    

    
      
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></script>
        <script src="http://assets2.github.com/javascripts/bundle.js?ae1e63835de171f1051825d37b863d72c8da7805" type="text/javascript"></script>
      
    
    
  
    
  

  <link href="http://github.com/feeds/technoweenie/commits/restful-authentication/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf" rel="alternate" title="Recent Commits to restful-authentication:61cd9b377c0b481384f123dc628a2f8cc5ea5fdf" type="application/atom+xml" />

  <meta name="description" content="Generates common user authentication code for Rails/Merb, with a full test/unit and rspec suite and optional Acts as State Machine support built-in." />


    
  </head>

  

  <body>
    

    <div id="main">
      <div id="header" class="">
        <div class="site">
          <div class="logo">
            <a href="http://github.com/"><img src="/images/modules/header/logov3.png" alt="github" /></a>
          </div>
          
            <div class="actions">
              <a href="http://github.com/">Home</a>
              <a href="/plans"><b><u>Pricing and Signup</u></b></a>
              <a href="/repositories">Repositories</a>
              <a href="/guides">Guides</a>
              <a href="/blog">Blog</a>
              <a href="/login">Login</a>
            </div>
          
        </div>
      </div>
      
      
        
  
  
    <div id="repo_menu">
      <div class="site">
        <ul>
          
            <li class=""><a href="http://github.com/technoweenie/restful-authentication/tree/">Source</a></li>
  
            <li class=""><a href="http://github.com/technoweenie/restful-authentication/commits/">Commits</a></li>
  
            <li class=""><a href="/technoweenie/restful-authentication/graphs">Graphs</a></li>
  
            <li class=""><a href="http://wiki.github.com/technoweenie/restful-authentication">Wiki (12)</a></li>
  
            <li class=""><a href="/technoweenie/restful-authentication/network">Network (146)</a></li>
  
            
            
            
  
          
        </ul>
      </div>
    </div>
  

  <div id="repo_sub_menu">
    <div class="site">
      <div class="joiner"></div>
      

      
      
      

      
    </div>
  </div>

  <div class="site">
    





<div id="repos">
  




  <div class="repo public">
    <div class="title">
      <div class="path">
        <a href="/technoweenie">technoweenie</a> / <b><a href="http://github.com/technoweenie/restful-authentication/tree">restful-authentication</a></b>

        

          

          
            

            
              
              <a href="/signup"><img alt="fork" class="button" src="http://assets3.github.com/images/modules/repos/fork_button.png?ae1e63835de171f1051825d37b863d72c8da7805" /></a>
            
          

          <a href="/signup" class="toggle_watch"><img alt="watch" class="button" src="http://assets2.github.com/images/modules/repos/watch_button.png?ae1e63835de171f1051825d37b863d72c8da7805" /></a><a href="/signup" class="toggle_watch" style="display:none;"><img alt="watch" class="button" src="http://assets2.github.com/images/modules/repos/unwatch_button.png?ae1e63835de171f1051825d37b863d72c8da7805" /></a>

          
            <a href="#" id="download_button" rel="http://github.com/technoweenie/restful-authentication/downloads/447866f2265b13a98fac43bc99da8ae4f34f6bc7"><img alt="download tarball" class="button" src="http://assets1.github.com/images/modules/repos/download_button.png?ae1e63835de171f1051825d37b863d72c8da7805" /></a>
          
        
      </div>

      <div class="security private_security" style="display:none">
        <a href="#private_repo" rel="facebox"><img src="/images/icons/private.png" alt="private" /></a>
      </div>

      <div id="private_repo" class="hidden">
        This repository is private.
        All pages are served over SSL and all pushing and pulling is done over SSH.
        No one may fork, clone, or view it unless they are added as a <a href="/technoweenie/restful-authentication/edit">member</a>.

        <br/>
        <br/>
        Every repository with this icon (<img src="/images/icons/private.png" alt="private" />) is private.
      </div>

      <div class="security public_security" style="">
        <a href="#public_repo" rel="facebox"><img src="/images/icons/public.png" alt="public" /></a>
      </div>

      <div id="public_repo" class="hidden">
        This repository is public.
        Anyone may fork, clone, or view it.

        <br/>
        <br/>
        Every repository with this icon (<img src="/images/icons/public.png" alt="public" />) is public.
      </div>

      

      <div class="flexipill">
        <a href="/technoweenie/restful-authentication/network">
        <table cellpadding="0" cellspacing="0">
          <tr><td><img alt="Forks" src="http://assets0.github.com/images/modules/repos/pills/forks.png?ae1e63835de171f1051825d37b863d72c8da7805" /></td><td class="middle"><span>146</span></td><td><img alt="Right" src="http://assets0.github.com/images/modules/repos/pills/right.png?ae1e63835de171f1051825d37b863d72c8da7805" /></td></tr>
        </table>
        </a>
      </div>

      <div class="flexipill">
        <a href="/technoweenie/restful-authentication/watchers">
        <table cellpadding="0" cellspacing="0">
          <tr><td><img alt="Watchers" src="http://assets3.github.com/images/modules/repos/pills/watchers.png?ae1e63835de171f1051825d37b863d72c8da7805" /></td><td class="middle"><span>1467</span></td><td><img alt="Right" src="http://assets0.github.com/images/modules/repos/pills/right.png?ae1e63835de171f1051825d37b863d72c8da7805" /></td></tr>
        </table>
        </a>
      </div>
    </div>
    <div class="meta">
      <table>
        
        
          <tr>
            <td class="label">Description:</td>
            <td>
              <span id="repository_description" rel="/technoweenie/restful-authentication/edit/update" class="">Generates common user authentication code for Rails/Merb, with a full test/unit and rspec suite and optional Acts as State Machine support built-in.</span>
              
            </td>
          </tr>
        

        
          
            <tr>
              <td class="label">Homepage:</td>
              <td>
                
                  
                  <a href="http://weblog.techno-weenie.net">http://weblog.techno-weenie.net</a>
                
              </td>
            </tr>
          

          
            <tr>
              <td class="label">Clone&nbsp;URL:</td>
              
              <td>
                <a href="git://github.com/technoweenie/restful-authentication.git" class="git_url_facebox" rel="#git-clone">git://github.com/technoweenie/restful-authentication.git</a>
                <div id="git-clone" style="display:none;">
                  Give this clone URL to anyone.
                  <br/>
                  <code>git clone git://github.com/technoweenie/restful-authentication.git </code>
                </div>
              </td>
            </tr>
          
          
          

          

          
      </table>

      
        <div class="pledgie">
          <a href='http://pledgie.org/campaigns/731'><img alt='Click here to lend your support to: restful-authentication and make a donation at www.pledgie.com !' src='http://www.pledgie.com/campaigns/731.png?skin_name=chrome' border='0' /></a>
        </div>
          </div>
  </div>




</div>


  <div id="commit">
    <div class="group">
        
  <div class="envelope commit">
    <div class="human">
      
        <div class="message"><pre><a href="/technoweenie/restful-authentication/commit/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf">incremented version in vain attempt to get github to acknowledge me</a> </pre></div>
      

      <div class="actor">
        <div class="gravatar">
          
          <img alt="" height="30" src="http://www.gravatar.com/avatar/356ad1a454b84f7a296af28312dc304c?s=30&amp;d=http%3A%2F%2Fgithub.com%2Fimages%2Fgravatars%2Fgravatar-30.png" width="30" />
        </div>
        <div class="name"><a href="/ggoodale">ggoodale</a> <span>(author)</span></div>
          <div class="date">
            <abbr class="relatize" title="2008-10-30 09:48:21">Thu Oct 30 09:48:21 -0700 2008</abbr> 
          </div>
      </div>
  
      
  
    </div>
    <div class="machine">
      <span>c</span>ommit&nbsp;&nbsp;<a href="/technoweenie/restful-authentication/commit/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf" hotkey="c">61cd9b377c0b481384f123dc628a2f8cc5ea5fdf</a><br />
      <span>t</span>ree&nbsp;&nbsp;&nbsp;&nbsp;<a href="/technoweenie/restful-authentication/tree/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf" hotkey="t">23338a0743069369f9a726145daaab75f6619df3</a><br />
  
      
        <span>p</span>arent&nbsp;
        
        <a href="/technoweenie/restful-authentication/tree/8cffaf6f8e99d263664ca7a402fb09dc39f606a7" hotkey="p">8cffaf6f8e99d263664ca7a402fb09dc39f606a7</a>
      
  
    </div>
  </div>

    </div>
  </div>





  
    <div id="path">
      <b><a href="/technoweenie/restful-authentication/tree">restful-authentication</a></b> / <a href="/technoweenie/restful-authentication/tree/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf/generators">generators</a> / <a href="/technoweenie/restful-authentication/tree/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf/generators/authenticated">authenticated</a> / <a href="/technoweenie/restful-authentication/tree/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf/generators/authenticated/templates">templates</a> / authenticated_test_helper.rb
    </div>

    <div id="files">
      <div class="file">
        <div class="meta">
          <div class="info">
            <span>100644</span>
            <span>23 lines (20 sloc)</span>
            <span>0.837 kb</span>
          </div>
          <div class="actions">
            
            <a href="/technoweenie/restful-authentication/raw/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf/generators/authenticated/templates/authenticated_test_helper.rb" id="raw-url">raw</a>
            
              <a href="/technoweenie/restful-authentication/blame/61cd9b377c0b481384f123dc628a2f8cc5ea5fdf/generators/authenticated/templates/authenticated_test_helper.rb">blame</a>
            
            <a href="/technoweenie/restful-authentication/commits/master/generators/authenticated/templates/authenticated_test_helper.rb">history</a>
          </div>
        </div>
        
  <div class="data syntax">
    
      <table cellpadding="0" cellspacing="0">
        <tr>
          <td>
            
            <pre class="line_numbers">
<span id="LID1" rel="#L1">1</span>
<span id="LID2" rel="#L2">2</span>
<span id="LID3" rel="#L3">3</span>
<span id="LID4" rel="#L4">4</span>
<span id="LID5" rel="#L5">5</span>
<span id="LID6" rel="#L6">6</span>
<span id="LID7" rel="#L7">7</span>
<span id="LID8" rel="#L8">8</span>
<span id="LID9" rel="#L9">9</span>
<span id="LID10" rel="#L10">10</span>
<span id="LID11" rel="#L11">11</span>
<span id="LID12" rel="#L12">12</span>
<span id="LID13" rel="#L13">13</span>
<span id="LID14" rel="#L14">14</span>
<span id="LID15" rel="#L15">15</span>
<span id="LID16" rel="#L16">16</span>
<span id="LID17" rel="#L17">17</span>
<span id="LID18" rel="#L18">18</span>
<span id="LID19" rel="#L19">19</span>
<span id="LID20" rel="#L20">20</span>
<span id="LID21" rel="#L21">21</span>
<span id="LID22" rel="#L22">22</span>
<span id="LID23" rel="#L23">23</span>
</pre>
          </td>
          <td width="100%">
            
            
              <div class="highlight"><pre><div class="line" id="LC1"><span class="k">module</span> <span class="nn">AuthenticatedTestHelper</span></div><div class="line" id="LC2">&nbsp;&nbsp;<span class="c1"># Sets the current &lt;%= file_name %&gt; in the session from the &lt;%= file_name %&gt; fixtures.</span></div><div class="line" id="LC3">&nbsp;&nbsp;<span class="k">def</span> <span class="nf">login_as</span><span class="p">(</span><span class="o">&lt;</span><span class="sx">%= file_name %&gt;)</span></div><div class="line" id="LC4"><span class="sx">    @request.session[:&lt;%=</span> <span class="n">file_name</span> <span class="sx">%&gt;_id] = &lt;%= file_name %&gt;</span> <span class="p">?</span> <span class="o">&lt;</span><span class="sx">%= table_name %&gt;(&lt;%=</span> <span class="n">file_name</span> <span class="sx">%&gt;).id : nil</span></div><div class="line" id="LC5"><span class="sx">  end</span></div><div class="line" id="LC6">&nbsp;</div><div class="line" id="LC7"><span class="sx">  def authorize_as(&lt;%= file_name %&gt;</span><span class="p">)</span></div><div class="line" id="LC8">&nbsp;&nbsp;&nbsp;&nbsp;<span class="vi">@request</span><span class="o">.</span><span class="n">env</span><span class="o">[</span><span class="s2">&quot;HTTP_AUTHORIZATION&quot;</span><span class="o">]</span> <span class="o">=</span> <span class="o">&lt;</span><span class="sx">%= file_name %&gt; ? ActionController::HttpAuthentication::Basic.encode_credentials(&lt;%=</span> <span class="n">table_name</span> <span class="sx">%&gt;(&lt;%= file_name %&gt;</span><span class="p">)</span><span class="o">.</span><span class="n">login</span><span class="p">,</span> <span class="s1">&#39;monkey&#39;</span><span class="p">)</span> <span class="p">:</span> <span class="kp">nil</span></div><div class="line" id="LC9">&nbsp;&nbsp;<span class="k">end</span></div><div class="line" id="LC10">&nbsp;&nbsp;</div><div class="line" id="LC11"><span class="o">&lt;</span><span class="sx">% if </span><span class="n">options</span><span class="o">[</span><span class="ss">:rspec</span><span class="o">]</span> <span class="o">-</span><span class="sx">%&gt;</span></div><div class="line" id="LC12"><span class="sx">  # rspec</span></div><div class="line" id="LC13"><span class="sx">  def mock_&lt;%= file_name %&gt;</span></div><div class="line" id="LC14">&nbsp;&nbsp;&nbsp;&nbsp;<span class="o">&lt;</span><span class="sx">%= file_name %&gt; =</span> <span class="n">mock_model</span><span class="p">(</span><span class="o">&lt;</span><span class="sx">%= class_name %&gt;, :id =</span><span class="o">&gt;</span> <span class="mi">1</span><span class="p">,</span></div><div class="line" id="LC15">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="ss">:login</span>  <span class="o">=&gt;</span> <span class="s1">&#39;user_name&#39;</span><span class="p">,</span></div><div class="line" id="LC16">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="ss">:name</span>   <span class="o">=&gt;</span> <span class="s1">&#39;U. Surname&#39;</span><span class="p">,</span></div><div class="line" id="LC17">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="ss">:to_xml</span> <span class="o">=&gt;</span> <span class="s2">&quot;&lt;%= class_name %&gt;-in-XML&quot;</span><span class="p">,</span> <span class="ss">:to_json</span> <span class="o">=&gt;</span> <span class="s2">&quot;&lt;%= class_name %&gt;-in-JSON&quot;</span><span class="p">,</span> </div><div class="line" id="LC18">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="ss">:errors</span> <span class="o">=&gt;</span> <span class="o">[]</span><span class="p">)</span></div><div class="line" id="LC19">&nbsp;&nbsp;&nbsp;&nbsp;<span class="o">&lt;%=</span> <span class="n">file_name</span> <span class="sx">%&gt;</span></div><div class="line" id="LC20"><span class="sx">  end  </span></div><div class="line" id="LC21"><span class="sx">&lt;% end -%&gt;</span></div><div class="line" id="LC22"><span class="k">end</span></div><div class="line" id="LC23">&nbsp;</div></pre></div>
            
          </td>
        </tr>
      </table>
    
  </div>


      </div>
    </div>
    
  


  </div>

      
      
      <div class="push"></div>
    </div>
    
    <div id="footer">
      <div class="site">
        <div class="info">
          <div class="links">
            <a href="http://github.com/blog/148-github-shirts-now-available">T-Shirts</a> |            
            <a href="http://github.com/blog">Blog</a> |             
            <a href="http://support.github.com/">Support</a> |
            <a href="http://github.com/training">Git Training</a> | 
            <a href="http://github.com/contact">Contact</a> |
            <a href="http://groups.google.com/group/github/">Google Group</a> | 
            <a href="http://github.wordpress.com">Status</a> 
          </div>
          <div class="company">
            <span id="_rrt" title="0.67607s from xc88-s00008">GitHub</span>
            is <a href="http://logicalawesome.com/">Logical Awesome</a> &copy;2009 | <a href="/site/terms">Terms of Service</a> | <a href="/site/privacy">Privacy Policy</a>
          </div>
        </div>
        <div class="sponsor">
          <a href="http://engineyard.com"><img src="/images/modules/footer/engine_yard_logo.png" alt="Engine Yard" /></a>
          <div>
            Hosting provided by our<br /> partners at Engine Yard
          </div>
        </div>
      </div>
    </div>
    
    <div id="coming_soon" style="display:none;">
      This feature is coming soon.  Sit tight!
    </div>

    
        <script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
    var pageTracker = _gat._getTracker("UA-3769691-2");
    pageTracker._initData();
    pageTracker._trackPageview();
    </script>

  </body>
</html>

