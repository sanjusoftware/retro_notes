require 'test_helper'

class RetroBoardsControllerTest < ActionController::TestCase
  setup do
    @retro_board = retro_boards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retro_boards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retro_board" do
    assert_difference('RetroBoard.count') do
      post :create, retro_board: { name: @retro_board.name, project_id: @retro_board.project_id }
    end

    assert_redirected_to retro_board_path(assigns(:retro_board))
  end

  test "should show retro_board" do
    get :show, id: @retro_board
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @retro_board
    assert_response :success
  end

  test "should update retro_board" do
    patch :update, id: @retro_board, retro_board: { name: @retro_board.name, project_id: @retro_board.project_id }
    assert_redirected_to retro_board_path(assigns(:retro_board))
  end

  test "should destroy retro_board" do
    assert_difference('RetroBoard.count', -1) do
      delete :destroy, id: @retro_board
    end

    assert_redirected_to retro_boards_path
  end
end
