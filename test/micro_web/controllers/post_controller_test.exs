defmodule MicroWeb.PostControllerTest do
  use MicroWeb.ConnCase

  alias Micro.Blog

  @create_attrs %{body: "some body", tags: "some tags", title: "some title", user: %{}}
  @update_attrs %{body: "some updated body", tags: "some updated tags", title: "some updated title"}
  @invalid_attrs %{body: nil, tags: nil, title: nil}

  @docp """
  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, user_post_path(conn, :index,)
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_post_path(conn, :new)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, user_post_path(conn, :create), post: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_user_post_path(conn, :show, id)

      conn = get conn, user_user_post_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_user_post_path(conn, :create), post: @invalid_attrs
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get conn, user_user_post_path(conn, :edit, post)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put conn, user_post_path(conn, :update, post), post: @update_attrs
      assert redirected_to(conn) == user_post_path(conn, :show, post)

      conn = get conn, user_post_path(conn, :show, post)
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put conn, user_post_path(conn, :update, post), post: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete conn, user_post_path(conn, :delete, post)
      assert redirected_to(conn) == user_post_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, user_post_path(conn, :show, post)
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end

  """
end
