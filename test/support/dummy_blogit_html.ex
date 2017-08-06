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

  def en_post_html1, do: @en_post_html1
  def en_post_html2, do: @en_post_html2
  def en_post_html3, do: @en_post_html3
  def en_post_html4, do: @en_post_html4

  def en_post_html do
    en_post_html1() <> en_post_html2() <> en_post_html3() <> en_post_html4()
  end
end
