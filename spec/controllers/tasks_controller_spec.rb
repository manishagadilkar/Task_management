require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) } 
  let(:task) { create(:task, user: user) }
  let(:valid_attributes) {
    attributes_for(:task)
  }
  let(:invalid_attributes) {
    { title: '', description: '', status: nil, deadline: nil }
  }

  before { sign_in user }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(assigns(:tasks)).to eq(user.tasks)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: task.to_param }
      expect(response).to be_successful
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: task.to_param }
      expect(response).to be_successful
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, params: { task: valid_attributes }
        expect(response).to redirect_to(Task.last)
      end
    end

    context "with invalid params" do
      it "renders the new template" do
        post :create, params: { task: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: 'New Title' }
      }

      it "updates the requested task" do
        put :update, params: { id: task.to_param, task: new_attributes }
        task.reload
        expect(task.title).to eq('New Title')
      end

      it "redirects to the task" do
        put :update, params: { id: task.to_param, task: valid_attributes }
        expect(response).to redirect_to(task)
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        put :update, params: { id: task.to_param, task: invalid_attributes }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task # Ensure the task is created before trying to delete it
      expect {
        delete :destroy, params: { id: task.to_param }
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      delete :destroy, params: { id: task.to_param }
      expect(response).to redirect_to(tasks_url)
    end
  end

  describe "authentication" do
    before { sign_out user }

    it "redirects to the login page if not authenticated on index" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
