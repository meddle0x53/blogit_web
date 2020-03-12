defmodule BlogitWeb.FeedControllerTest do
  use BlogitWeb.Web.ConnCase

  def assert_rss(conn, content) do
    assert conn.status == 200
    response_content_type(conn, :xml) =~ "charset=utf-8"

    assert conn.resp_body == content
  end

  def assert_default_locale_rss(conn) do
    item_link1 = "http://localhost:4001/posts/post1"
    item_link2 = "http://localhost:4001/posts/post2"
    item_link3 = "http://localhost:4001/posts/post3"
    item_link4 = "http://localhost:4001/posts/post4"

    item_cdata3 =
      ~s(<h1>Third Bost</h1><a href="#{item_link1}">A link</a>) <>
        "<a href=#{item_link3}>[...]</a>"

    rss = """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>My blog</title>
        <description></description>
        <link>http://localhost:4001/posts</link>
          <item>
            <title>
              <![CDATA[Post One]]>
            </title>
            <link>#{item_link1}</link>
            <description>
              <![CDATA[<h1>First Bost</h1><a href=#{item_link1}>[...]</a>]]>
            </description>
            <pubDate>Sun, 21 May 2017 08:46:50 +0000</pubDate>
            <guid isPermaLink="true">#{item_link1}</guid>
          </item>
          <item>
            <title>
              <![CDATA[Post Two]]>
            </title>
            <link>#{item_link2}</link>
            <description>
              <![CDATA[<h1>Second Bost</h1><a href=#{item_link2}>[...]</a>]]>
            </description>
            <pubDate>Tue, 25 Jul 2017 18:36:33 +0000</pubDate>
            <guid isPermaLink="true">#{item_link2}</guid>
          </item>
          <item>
            <title>
              <![CDATA[Post Three]]>
            </title>
            <link>#{item_link3}</link>
            <description>
              <![CDATA[#{item_cdata3}]]>
            </description>
            <pubDate>Wed, 26 Apr 2017 16:26:26 +0000</pubDate>
            <guid isPermaLink="true">#{item_link3}</guid>
          </item>
          <item>
            <title>
              <![CDATA[Post Four]]>
            </title>
            <link>#{item_link4}</link>
            <description>
              <![CDATA[<h1>Fourth Bost</h1><a href=#{item_link4}>[...]</a>]]>
            </description>
            <pubDate>Mon, 13 Mar 2017 21:55:26 +0000</pubDate>
            <guid isPermaLink="true">#{item_link4}</guid>
          </item>
      </channel>
    </rss>
    """

    assert_rss(conn, rss)
  end

  setup_all do
    Application.put_env(:blogit_web, :backend_implementation, DummyBlogit)
    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/feed")

    assert_default_locale_rss(conn)
  end

  test "GET / with locale", %{conn: conn} do
    conn = get(conn, "/en/feed")

    assert_default_locale_rss(conn)
  end

  test "GET / with alternative locale", %{conn: conn} do
    conn = get(conn, "/bg/feed")

    item_link1 =
      "http://localhost:4001/bg/posts/" <>
        "%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F1"

    item_link2 =
      "http://localhost:4001/bg/posts/" <>
        "%D0%BF%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F2"

    title1 = "Първа Бубликация"
    title2 = "Втора Бубликация"

    item_cdata2 =
      "<h1>#{title2}</h1>" <>
        ~s(<a href="http://localhost:4001/bg/posts/so">A link</a>) <>
        "<a href=#{item_link2}>[...]</a>"

    rss = """
    <?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
      <channel>
        <title>Моят блог</title>
        <description></description>
        <link>http://localhost:4001/bg/posts</link>
          <item>
            <title>
              <![CDATA[]]>
            </title>
            <link>#{item_link1}</link>
            <description>
              <![CDATA[<h1>#{title1}</h1><a href=#{item_link1}>[...]</a>]]>
            </description>
            <pubDate>Sun, 21 May 2017 08:46:50 +0000</pubDate>
            <guid isPermaLink="true">#{item_link1}</guid>
          </item>
          <item>
            <title>
              <![CDATA[]]>
            </title>
            <link>#{item_link2}</link>
            <description>
              <![CDATA[#{item_cdata2}]]>
            </description>
            <pubDate>Thu, 15 Jun 2017 15:18:39 +0000</pubDate>
            <guid isPermaLink="true">#{item_link2}</guid>
          </item>
      </channel>
    </rss>
    """

    assert_rss(conn, rss)
  end
end
