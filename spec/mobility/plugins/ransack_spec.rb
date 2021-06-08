# frozen_string_literal: true

require "mobility/plugins/ransack"

RSpec.describe Mobility::Plugins::Ransack do

  it "generates correct SQL for translated attributes" do
    expect(Post.ransack(title_cont: "foo", content_eq: "bar").result.to_sql).to eq(
      %q{SELECT "posts".* FROM "posts" LEFT OUTER JOIN "mobility_string_translations" "Post_title_en_string_translations" ON "Post_title_en_string_translations"."key" = 'title' AND "Post_title_en_string_translations"."locale" = 'en' AND "Post_title_en_string_translations"."translatable_type" = 'Post' AND "Post_title_en_string_translations"."translatable_id" = "posts"."id" INNER JOIN "mobility_text_translations" "Post_content_en_text_translations" ON "Post_content_en_text_translations"."key" = 'content' AND "Post_content_en_text_translations"."locale" = 'en' AND "Post_content_en_text_translations"."translatable_type" = 'Post' AND "Post_content_en_text_translations"."translatable_id" = "posts"."id" WHERE ("Post_title_en_string_translations"."value" LIKE '%foo%' AND "Post_content_en_text_translations"."value" = 'bar')}
    )
  end

  it "finds correct records with translated search queries" do
    posts = %w[foo foo123 123foo].map { |title| Post.create(title: title) }

    aggregate_failures do
      expect(Post.ransack(title_cont: "foo").result.to_a).to match_array(posts)
      expect(Post.ransack(title_start: "foo").result.to_a).to match_array(posts[0..1])
      expect(Post.ransack(title_end: "foo").result.to_a).to match_array([posts[0], posts[2]])
    end
  end

  it "sorts on translated attributes" do
    posts = %w[foo2 foo1 foo3].map { |title| Post.create(title: title) }

    aggregate_failures do
      expect(Post.ransack(s: ['title asc']).result.to_a).to match_array([posts[1], posts[0], posts[2]])
      expect(Post.ransack(s: ['title desc']).result.to_a).to match_array([posts[2], posts[0], posts[1]])
    end
  end

  it 'finds by translated fields of has_many accossiation' do
    author = Author.create!
    skiped_author = Author.create!
    post = Post.create!(author: author, title: 'foo')

    expect(Author.ransack(posts_title_cont: 'foo').result.to_a).to match_array([author])
  end

  it 'finds by translated fields of belongs_to accossiation' do
    author = Author.create!(website: 'google.com')
    post = Post.create!(author: author, title: 'foo')
    skiped_post = Post.create!

    expect(Post.ransack(author_website_start: 'google').result.to_a).to match_array([post])
  end

  it 'handles grouping search with translated fields with associations' do
    google_author = Author.create!(website: 'google.com')
    google_post = Post.create!(author: google_author, title: 'The new things in Firebase', tags: 'firebase lighthouse')
    verge_author = Author.create!(website: 'verge.com')
    verge_post = Post.create!(author: verge_author, title: 'Google and GDPR policy in Europe', tags: 'gdpr google europe')

    aggregate_failures do
      expect(Post.ransack(title_cont: 'google', author_website_start: 'google', m: 'or').result.to_a).to match_array([google_post, verge_post])
      expect(Post.ransack(tags_cont: 'google', author_website_start: 'google', m: 'or').result.to_a).to match_array([google_post, verge_post])
      expect(Post.ransack(tags_cont: 'google', title_cont: 'google', m: 'and').result.to_a).to match_array([verge_post])
    end
  end
end
