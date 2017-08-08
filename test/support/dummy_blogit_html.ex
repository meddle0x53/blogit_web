defmodule DummyBlogitHTML do
  @en_post_html1 ~S"""
      <div class="post-row post-stream-row">
        <article class="post">
          <h2 class="post-title-container">
            <a class="post-title-link" href="/posts/post1">
  Post One          </a>
          </h2>
          <p class="post-author">
          by <span class="post-author-name">
  <a href="/posts?author=meddle">meddle</a>        </span>
          </p>
          <hr class="before-post-date" />
          <div class="post-date">
            Posted on <span class="post-author-created">Sunday, 21 May 2017, 08:46</span>
          </div>
          <hr class="after-post-date" />
          <h1>First Bost</h1><a href=/posts/post1><h4>[...]</h4></a>
          <hr class="post-divider" />
        </article>
      </div>
  """

  @en_post_html2 ~S"""
      <div class="post-row post-stream-row">
        <article class="post">
          <h2 class="post-title-container">
            <a class="post-title-link" href="/posts/post2">
  Post Two          </a>
          </h2>
          <p class="post-author">
          by <span class="post-author-name">
  <a href="/posts?author=slavi">slavi</a>        </span>
          </p>
          <hr class="before-post-date" />
          <div class="post-date">
            Posted on <span class="post-author-created">Tuesday, 25 July 2017, 18:36</span>
          </div>
          <hr class="after-post-date" />
          <h1>Second Bost</h1><a href=/posts/post2><h4>[...]</h4></a>
          <hr class="post-divider" />
        </article>
      </div>
  """

  @en_post_html3 ~S"""
      <div class="post-row post-stream-row">
        <article class="post">
          <h2 class="post-title-container">
            <a class="post-title-link" href="/posts/post3">
  Post Three          </a>
          </h2>
          <p class="post-author">
          by <span class="post-author-name">
  <a href="/posts?author=valo">valo</a>        </span>
          </p>
          <hr class="before-post-date" />
          <div class="post-date">
            Posted on <span class="post-author-created">Wednesday, 26 April 2017, 16:26</span>
          </div>
          <hr class="after-post-date" />
          <h1>Third Bost</h1><a href="/posts/post1">A link</a><a href=/posts/post3><h4>[...]</h4></a>
          <hr class="post-divider" />
        </article>
      </div>
  """

  @en_post_html4 ~S"""
      <div class="post-row post-stream-row">
        <article class="post">
          <h2 class="post-title-container">
            <a class="post-title-link" href="/posts/post4">
  Post Four          </a>
          </h2>
          <p class="post-author">
          by <span class="post-author-name">
  <a href="/posts?author=andi">andi</a>        </span>
          </p>
          <hr class="before-post-date" />
          <div class="post-date">
            Posted on <span class="post-author-created">Monday, 13 March 2017, 21:55</span>
          </div>
          <hr class="after-post-date" />
          <h1>Fourth Bost</h1><a href=/posts/post4><h4>[...]</h4></a>
          <hr class="post-divider" />
        </article>
      </div>
  """

  @en_post_whole_html3 """
  <div class="post-row">
    <article class="post">
      <h2 class="post-title-container">
        <a class="post-title-link" href="/posts/post3">
  Post Three      </a>
      </h2>
      <p class="post-author">
      by <span class="post-author-name">
  <a href="/posts?author=valo">valo</a>    </span>
      </p>
      <hr class="before-post-date" />
      <div class="post-date">
        Posted on <span class="post-author-created">Wednesday, 26 April 2017, 16:26</span>
      </div>
      <hr class="after-post-date" />
      <h1>Third Bost</h1><a href="/posts/post1">A link</a>
      <hr class="post-footer-divider" />
      <div class="post-footer">
  <div class='post-category'><span class=post-category-name>  <a href="/posts?category=uncategorized">uncategorized</a>
  </span></div>      
      </div>
      <hr class="post-divider" />
      <!-- AddToAny BEGIN -->
      <div class="a2a_kit a2a_kit_size_32 a2a_default_style">
        <a class="a2a_button_facebook"></a>
        <a class="a2a_button_twitter"></a>
        <a class="a2a_button_linkedin"></a>
        <a class="a2a_button_email"></a>
        <a class="a2a_dd" href="https://www.addtoany.com/share"></a>
      </div>
      <script async src="https://static.addtoany.com/menu/page.js"></script>
      <!-- AddToAny END -->
      <hr class="post-footer-divider" />
    </article>
  </div>
  <div id="disqus_thread"></div>
  """

  @bg_post_html1 """
      <div class="post-row post-stream-row">
        <article class="post">
          <h2 class="post-title-container">
            <a class="post-title-link" href="/bg/posts/%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F1">
            </a>
          </h2>
          <p class="post-author">
          от <span class="post-author-name">
  <a href="/bg/posts?author="></a>        </span>
          </p>
          <hr class="before-post-date" />
          <div class="post-date">
            Публикувано <span class="post-author-created">неделя, 21 май 2017, 08:46</span>
          </div>
          <hr class="after-post-date" />
          <h1>Първа Бубликация</h1><a href=/bg/posts/%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F1><h4>[...]</h4></a>
          <hr class="post-divider" />
        </article>
      </div>
  """

  @bg_post_html2 """
      <div class="post-row post-stream-row">
        <article class="post">
          <h2 class="post-title-container">
            <a class="post-title-link" href="/bg/posts/%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F2">
            </a>
          </h2>
          <p class="post-author">
          от <span class="post-author-name">
  <a href="/bg/posts?author="></a>        </span>
          </p>
          <hr class="before-post-date" />
          <div class="post-date">
            Публикувано <span class="post-author-created">четвъртък, 15 юни 2017, 15:18</span>
          </div>
          <hr class="after-post-date" />
          <h1>Втора Бубликация</h1><a href="/bg/posts/so">A link</a><a href=/bg/posts/%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F2><h4>[...]</h4></a>
          <hr class="post-divider" />
        </article>
      </div>
  """

  @bg_post_whole_html1 """
  <div class="post-row">
    <article class="post">
      <h2 class="post-title-container">
        <a class="post-title-link" href="/bg/posts/%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F1">
        </a>
      </h2>
      <p class="post-author">
      от <span class="post-author-name">
  <a href="/bg/posts?author="></a>    </span>
      </p>
      <hr class="before-post-date" />
      <div class="post-date">
        Публикувано <span class="post-author-created">неделя, 21 май 2017, 08:46</span>
      </div>
      <hr class="after-post-date" />
      <h1>Първа Бубликация</h1>
      <hr class="post-footer-divider" />
      <div class="post-footer">
  <div class='post-category'>Категоризирано като <span class=post-category-name>  <a href="/bg/posts?category=Test">Test</a>
  </span></div>      
      </div>
      <hr class="post-divider" />
      <!-- AddToAny BEGIN -->
      <div class="a2a_kit a2a_kit_size_32 a2a_default_style">
        <a class="a2a_button_facebook"></a>
        <a class="a2a_button_twitter"></a>
        <a class="a2a_button_linkedin"></a>
        <a class="a2a_button_email"></a>
        <a class="a2a_dd" href="https://www.addtoany.com/share"></a>
      </div>
      <script async src="https://static.addtoany.com/menu/page.js"></script>
      <!-- AddToAny END -->
      <hr class="post-footer-divider" />
    </article>
  </div>
  <div id="disqus_thread"></div>
  """

  def en_post_html1, do: @en_post_html1
  def en_post_html2, do: @en_post_html2
  def en_post_html3, do: @en_post_html3
  def en_post_html4, do: @en_post_html4

  def en_post_whole_html3, do: @en_post_whole_html3

  def bg_post_html1, do: @bg_post_html1
  def bg_post_html2, do: @bg_post_html2

  def bg_post_whole_html1, do: @bg_post_whole_html1

  def en_post_html do
    en_post_html1() <> en_post_html2() <> en_post_html3() <> en_post_html4()
  end

  def bg_post_html do
    bg_post_html1() <> bg_post_html2()
  end
end
