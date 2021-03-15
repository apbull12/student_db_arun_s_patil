class StudentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[registration create]

  before_action :set_student, only: %i[show edit update destroy accept_student]
  # before_action :set_institution, only: :search

  # GET /students
  # GET /students.json
  def index
    @students = Student.accepted.paginate(page: params[:page], per_page: 10).order(id: :desc)
  end

  # GET /students/1
  # GET /students/1.json
  def show; end

  # GET /students/new
  def new
    @student = Student.new
  end

  def registration
    @student = Student.new
    respond_to do |format|
      format.html { render :registration_form }
    end
  end

  # GET /students/1/edit
  def edit; end

  def search
    if params[:student_name].blank? && params[:institution_name].blank?
      redirect_to(root_path, alert: 'Empty Field!') && nil
    else
      @search_result = Student.accepted.joins(:institution).where('lower(name) like (?) AND lower(full_name) LIKE (?)', "%#{params[:institution_name].downcase}%", "%#{params[:student_name].downcase}%").paginate(page: params[:page], per_page: 10)
      respond_to do |format|
        format.html { render :search }
      end
    end
  end

  def accept_student
    @student.status = 'accepted' if current_user.present?

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student Accepted successfully.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def list_pending_request
    @students = Student.get_pending.paginate(page: params[:page], per_page: 10).order(id: :desc)
    respond_to do |format|
      format.html { render :pending_requests }
    end
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    if current_user.present?
      @student.status = 'accepted'

      respond_to do |format|
        if @student.save
          format.html { redirect_to @student, notice: 'Student was successfully created.' }
          format.json { render :show, status: :created, location: @student }
        else
          format.html { render :new }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @student.save
          format.html { render :register_thanks }
        else
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_by_full_name
    if params[:v_order] == 'down'
      @students = Student.paginate(page: params[:page], per_page: 10).order(full_name: :desc)
    else
      @students = Student.paginate(page: params[:page], per_page: 10).order(:full_name)
    end
    respond_to do |format|
      format.html { render :index }
    end
  end

  def list_by_institution
    if params[:i_order] == 'down'
      @students = Student.joins(:institution).paginate(page: params[:page], per_page: 10).order(name: :desc)
    else
      @students = Student.joins(:institution).paginate(page: params[:page], per_page: 10).order(:name)
    end
    respond_to do |format|
      format.html { render :index }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  def set_institution
    @institution_ids = Institution.where('lower(name) LIKE (?)', "%#{params[:institution_name]}%").pluck(:id) if params[:institution_name].present?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:full_name, :address, :mobile,
                                    :institution_id, :page, :student_name, :institution_name)
  end
end
