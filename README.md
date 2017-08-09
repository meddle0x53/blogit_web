# How to create your own blog with Blogit?

Welcome to [BlogitWeb](https://github.com/meddle0x53/blogit_web), the web blog platform, using [Blogit](https://github.com/meddle0x53/blogit) as its engine.
In this little article, we will try to help you create your own blog.

Let's start!

## What is Blogit? What is BlogitWeb?

BlogitWeb is written in [Elixir](https://elixir-lang.org/), using the
[Phoenix](http://phoenixframework.org/) web framework. It is a simple application
which serves as a front-end to the [Blogit](https://github.com/meddle0x53/blogit) blog engine.

What is Blogit?
Blogit is a blog engine back-end written in Elixir.
It turns a repository (by default git repository),
containing markdown files into streams of blog posts, which can be queried.
Blogit supports blog configuration in YAML, including blog title, path to custom styles and images, etc.

Now that we know what's what, lets try to create our own blog.

## Fork and run BlogitWeb in dev mode

### Requirements

1. You'll need Elixir. [Install it](https://elixir-lang.org/install.html) and be sure that its version is greater or equal to `1.5`.
2. You'll need [Node.js](https://nodejs.org/en/). [Install it](https://nodejs.org/en/download/) on your computer as Phoenix uses it for digesting its assets.

### Fork and run

Fork [BlogitWeb](https://github.com/meddle0x53/blogit_web).

As we said, BlogitWeb is a Phoenix application, so we can run it in development mode by:
```bash
git clone https://github.com/<your-user>/blogit_web
cd blogit_web

mix deps.get
npm install
mix phoenix.server
```

This will start a server on `localhost:4000` (the port can be changed in `config/dev.exs`).
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

You'll see a simple blog with this text as the single post in it!

## Configure your own blog in dev mode

The configuration of the blog for the dev mode is located in `config/dev.exs`.
The important bits are:

```elixir
config :blogit,
  repository_url: "https://github.com/meddle0x53/blogit_sample",
  polling: false, max_lines_in_preview: 5,
  languages: ~w(en bg)
```

The `repository_url` points to the repository containing your posts in markdown format.
Create a new repository somewhere (github?) and overwrite the default `blogit_sample` one.
Run

```bash
mix deps.clean blogit
mix deps.update blogit
```

If you run

```bash
mix phoenix.server
```

you'll have an empty blog and you'll notice that your repository was cloned into the
root of the BlogitWeb project.

Before adding posts to your blog repository, let's look at the other settings, you can configure in `config/dev.exs`.
Possible settings are:

* `repository_url`       |> Tells Blogit the location of the repository to use to build its contents.
* `polling`              |> Tells Blogit if it should poll the repository specified through `repository_url` for changes. By default it is `true`.
* `poll_interval`        |> Used if `polling` is set to `true`. The polling for changes will happen on this interval of seconds. By default it is `10` seconds.
* `repository_provider`  |> Specified a specific implementation of the [Blogit.RepositoryProvider](https://github.com/meddle0x53/blogit/blob/master/lib/blogit/repository_provider.ex) behaviour. By default it uses `Blogit.RepositoryProviders.Git` which works with git repositories and knows how to check for changes in them.
* `configuration_file`   |> Path to YAML file in the repository, which contains configuration for the blog. By default it is `blog.yml`.
* `languages`            |> A list of language codes. By default it is `["en"]`. The first language of the list is the default and primaty language. If there are alternative languages, if post source files are created in the folder `<repo-root>/posts/<lang-code>`, the posts compiled from them are marked that are in the given language. They can be queried with `Blogit.list_posts(language: "<lang-code>")`.
* `max_lines_in_preview` |> The maximum lines to be used from the content of the original post source to generate its preview. The preview is generated from the beginning of the content and contains maximum `max_lines_in_preview` lines. By default this value is `10`.

For production you should set the `polling` to `true` and some `poll_interval`, but for dev you can leave them as they are in `config/dev.exs`.

The engine supports multiple languages and in the sample it is configured to show both English and Bulgarian post streams. You can remove the `bg` from the list
and will have single-language blog in English. For more languages, translations have to be added to BlogitWeb. See `priv/gettext` for how they look like and do a PR for your language.

Don't forget to run `mix do deps.clean blogit, deps.update blogit` after modifying the configuration.
The idea is that this configuration is a constant and will be modified only in the very beginning of the creation of the blog.


## Blog content

Let's start with the title and the look and feel of your blog.

### Blog configuration

The default configuration file for the blog is `blog.yml`, this can be changed with the `:configuration_file` setting from above.
Let's leave it `blog.yml` for now.

This is the place you can add title, custom styles and logo for your blog. This is an example `blog.yml`:

```yaml
title: Sample Blog
sub_title: Some sample sub-title
logo_path: assets/logo.png
styles_path: assets/styles.css
background_image_path: assets/other_image.jpg
social:
  rss: true
  twitter: ntzvetinov
  github: meddle0x53
  facebook: meddle0x53
  stars_for_blogit: false
bg:
  title: Примерен блог
  sub_title: Some sample sub-title-in-bulgarian
  social:
    rss: false
```

Create your own file similar to this. The title and sub-title are shown on every page
as header, the titles can have background image or logo and you can overwrite the default CSS.
Notice that all the files are in an `assets` folder. You have to create one in your blog repository and put them there,
they'll be served by BlogitWeb.

The social section is for links to social media. By default you have RSS feed, but it can be turned off.
Also by default there are links for giving Blogit and BlogitWeb stars in Github. These can be turned off too.
If you want to have links to your Twitter, Github and/or Facebook profiles, just add your handles.

If you have secondary language, you can override some of the setting you defined in a section under the code of the language.
Everything else is derived.

### Posts

Posts should be markdown files residing in the blog repository under a folder named `posts`.
That's it, they'll be shown in the blog. Their creation date and author will be retrieved from the git history.

You can add custom meta data to every post. Just add it in the markdown file before the content like in [this post](https://github.com/meddle0x53/blogit_sample/blob/master/posts/make_your_own_blog.md).

Meta data could be custom `author` name, `category`, list of `tags`, custom `created_at` and `updated_at` dates (if you don't want them from the git history) in ISO 8601 format.
You can also add `pinned: true` and the post will be shown in a special list of pinned posts.
Posts can have `title_image_path` for an image under the title (900x300 is the best size for it).

If you want posts streams for alternate languages, just create sub-folder of `posts` with name the code of the language
and add the posts there. For example a post in Bulgarian should have similar path : `posts/bg/some_post.md`.

### Custom styles and contributions

With the `styles_path` configuration you can add custom CSS to your blog, but it could turn out this is not
enough. We encourage you to contribute to [BlogitWeb](https://github.com/meddle0x53/blogit_web) with PRs and issues.

## Production

The BlogitWeb project uses [Distillery](https://github.com/bitwalker/distillery) for building releases.
It comes with a little script, so you can try it in production mode.
Don't forget to modify `config/prod.exs` with the settings for your blog and run `mix do deps.clean blogit, deps.update blogit` before that.
Run

```bash
./build_release.sh
```

After it finishes, you can try your blog in production mode

```bash
_build/prod/rel/blogit_web/bin/blogit_web foreground
```

## Deployment

For deployment you can follow these cool guides by [Chak Zia Zek](https://zekinteractive.com/):

https://medium.com/@zek/deploy-early-and-often-deploying-phoenix-with-edeliver-and-distillery-part-one-5e91cac8d4bd

and

https://medium.com/@zek/deploy-early-and-often-deploying-phoenix-with-edeliver-and-distillery-part-two-f361ef36aa10

You won't need Ecto and Postgres for BlogitWeb.

BlogitWeb depends on [Edeliver](https://github.com/edeliver/edeliver), so you can modify `.deliver/config` with the IP of your host and just run:

```bash
mix edeliver build release production --verbose
mix edeliver deploy release to production

mix edeliver start production
```

If you followed the guides and did the right modifications all will run fine.

Alternatively we have `Dockerfile.build` to build BlogitWeb with Docker and a `Dockerfile` to deploy it
to a docker-enabled host.
