defmodule AuditorActivity.GenericTest do
  use AuditorActivity.DataCase

  alias AuditorActivity.Generic

  describe "project_types" do
    alias AuditorActivity.Generic.ProjectType

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def project_type_fixture(attrs \\ %{}) do
      {:ok, project_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_project_type()

      project_type
    end

    test "list_project_types/0 returns all project_types" do
      project_type = project_type_fixture()
      assert Generic.list_project_types() == [project_type]
    end

    test "get_project_type!/1 returns the project_type with given id" do
      project_type = project_type_fixture()
      assert Generic.get_project_type!(project_type.id) == project_type
    end

    test "create_project_type/1 with valid data creates a project_type" do
      assert {:ok, %ProjectType{} = project_type} = Generic.create_project_type(@valid_attrs)
      assert project_type.description == "some description"
      assert project_type.name == "some name"
    end

    test "create_project_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_project_type(@invalid_attrs)
    end

    test "update_project_type/2 with valid data updates the project_type" do
      project_type = project_type_fixture()
      assert {:ok, %ProjectType{} = project_type} = Generic.update_project_type(project_type, @update_attrs)
      assert project_type.description == "some updated description"
      assert project_type.name == "some updated name"
    end

    test "update_project_type/2 with invalid data returns error changeset" do
      project_type = project_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_project_type(project_type, @invalid_attrs)
      assert project_type == Generic.get_project_type!(project_type.id)
    end

    test "delete_project_type/1 deletes the project_type" do
      project_type = project_type_fixture()
      assert {:ok, %ProjectType{}} = Generic.delete_project_type(project_type)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_project_type!(project_type.id) end
    end

    test "change_project_type/1 returns a project_type changeset" do
      project_type = project_type_fixture()
      assert %Ecto.Changeset{} = Generic.change_project_type(project_type)
    end
  end

  describe "tasks" do
    alias AuditorActivity.Generic.Task

    @valid_attrs %{description: "some description", name: "some name", status: "some status", time_to_finish: "2010-04-17T14:00:00Z"}
    @update_attrs %{description: "some updated description", name: "some updated name", status: "some updated status", time_to_finish: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{description: nil, name: nil, status: nil, time_to_finish: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Generic.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Generic.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Generic.create_task(@valid_attrs)
      assert task.description == "some description"
      assert task.name == "some name"
      assert task.status == "some status"
      assert task.time_to_finish == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Generic.update_task(task, @update_attrs)
      assert task.description == "some updated description"
      assert task.name == "some updated name"
      assert task.status == "some updated status"
      assert task.time_to_finish == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_task(task, @invalid_attrs)
      assert task == Generic.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Generic.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Generic.change_task(task)
    end
  end

  describe "checklists" do
    alias AuditorActivity.Generic.Checklist

    @valid_attrs %{description: "some description", name: "some name", status: "some status", time_to_finish: "2010-04-17T14:00:00Z"}
    @update_attrs %{description: "some updated description", name: "some updated name", status: "some updated status", time_to_finish: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{description: nil, name: nil, status: nil, time_to_finish: nil}

    def checklist_fixture(attrs \\ %{}) do
      {:ok, checklist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_checklist()

      checklist
    end

    test "list_checklists/0 returns all checklists" do
      checklist = checklist_fixture()
      assert Generic.list_checklists() == [checklist]
    end

    test "get_checklist!/1 returns the checklist with given id" do
      checklist = checklist_fixture()
      assert Generic.get_checklist!(checklist.id) == checklist
    end

    test "create_checklist/1 with valid data creates a checklist" do
      assert {:ok, %Checklist{} = checklist} = Generic.create_checklist(@valid_attrs)
      assert checklist.description == "some description"
      assert checklist.name == "some name"
      assert checklist.status == "some status"
      assert checklist.time_to_finish == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_checklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_checklist(@invalid_attrs)
    end

    test "update_checklist/2 with valid data updates the checklist" do
      checklist = checklist_fixture()
      assert {:ok, %Checklist{} = checklist} = Generic.update_checklist(checklist, @update_attrs)
      assert checklist.description == "some updated description"
      assert checklist.name == "some updated name"
      assert checklist.status == "some updated status"
      assert checklist.time_to_finish == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_checklist/2 with invalid data returns error changeset" do
      checklist = checklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_checklist(checklist, @invalid_attrs)
      assert checklist == Generic.get_checklist!(checklist.id)
    end

    test "delete_checklist/1 deletes the checklist" do
      checklist = checklist_fixture()
      assert {:ok, %Checklist{}} = Generic.delete_checklist(checklist)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_checklist!(checklist.id) end
    end

    test "change_checklist/1 returns a checklist changeset" do
      checklist = checklist_fixture()
      assert %Ecto.Changeset{} = Generic.change_checklist(checklist)
    end
  end

  describe "checkpoints" do
    alias AuditorActivity.Generic.Checkpoint

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def checkpoint_fixture(attrs \\ %{}) do
      {:ok, checkpoint} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_checkpoint()

      checkpoint
    end

    test "list_checkpoints/0 returns all checkpoints" do
      checkpoint = checkpoint_fixture()
      assert Generic.list_checkpoints() == [checkpoint]
    end

    test "get_checkpoint!/1 returns the checkpoint with given id" do
      checkpoint = checkpoint_fixture()
      assert Generic.get_checkpoint!(checkpoint.id) == checkpoint
    end

    test "create_checkpoint/1 with valid data creates a checkpoint" do
      assert {:ok, %Checkpoint{} = checkpoint} = Generic.create_checkpoint(@valid_attrs)
      assert checkpoint.name == "some name"
    end

    test "create_checkpoint/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_checkpoint(@invalid_attrs)
    end

    test "update_checkpoint/2 with valid data updates the checkpoint" do
      checkpoint = checkpoint_fixture()
      assert {:ok, %Checkpoint{} = checkpoint} = Generic.update_checkpoint(checkpoint, @update_attrs)
      assert checkpoint.name == "some updated name"
    end

    test "update_checkpoint/2 with invalid data returns error changeset" do
      checkpoint = checkpoint_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_checkpoint(checkpoint, @invalid_attrs)
      assert checkpoint == Generic.get_checkpoint!(checkpoint.id)
    end

    test "delete_checkpoint/1 deletes the checkpoint" do
      checkpoint = checkpoint_fixture()
      assert {:ok, %Checkpoint{}} = Generic.delete_checkpoint(checkpoint)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_checkpoint!(checkpoint.id) end
    end

    test "change_checkpoint/1 returns a checkpoint changeset" do
      checkpoint = checkpoint_fixture()
      assert %Ecto.Changeset{} = Generic.change_checkpoint(checkpoint)
    end
  end

  describe "projects" do
    alias AuditorActivity.Generic.Project

    @valid_attrs %{end_date: ~D[2010-04-17], name: "some name", start_date: ~D[2010-04-17]}
    @update_attrs %{end_date: ~D[2011-05-18], name: "some updated name", start_date: ~D[2011-05-18]}
    @invalid_attrs %{end_date: nil, name: nil, start_date: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Generic.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Generic.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Generic.create_project(@valid_attrs)
      assert project.end_date == ~D[2010-04-17]
      assert project.name == "some name"
      assert project.start_date == ~D[2010-04-17]
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = Generic.update_project(project, @update_attrs)
      assert project.end_date == ~D[2011-05-18]
      assert project.name == "some updated name"
      assert project.start_date == ~D[2011-05-18]
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_project(project, @invalid_attrs)
      assert project == Generic.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Generic.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Generic.change_project(project)
    end
  end

  describe "project_tasks" do
    alias AuditorActivity.Generic.ProjecttypeTask

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def project_task_fixture(attrs \\ %{}) do
      {:ok, project_task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_project_task()

      project_task
    end

    test "list_project_tasks/0 returns all project_tasks" do
      project_task = project_task_fixture()
      assert Generic.list_project_tasks() == [project_task]
    end

    test "get_project_task!/1 returns the project_task with given id" do
      project_task = project_task_fixture()
      assert Generic.get_project_task!(project_task.id) == project_task
    end

    test "create_project_task/1 with valid data creates a project_task" do
      assert {:ok, %ProjecttypeTask{} = project_task} = Generic.create_project_task(@valid_attrs)
    end

    test "create_project_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_project_task(@invalid_attrs)
    end

    test "update_project_task/2 with valid data updates the project_task" do
      project_task = project_task_fixture()
      assert {:ok, %ProjecttypeTask{} = project_task} = Generic.update_project_task(project_task, @update_attrs)
    end

    test "update_project_task/2 with invalid data returns error changeset" do
      project_task = project_task_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_project_task(project_task, @invalid_attrs)
      assert project_task == Generic.get_project_task!(project_task.id)
    end

    test "delete_project_task/1 deletes the project_task" do
      project_task = project_task_fixture()
      assert {:ok, %ProjecttypeTask{}} = Generic.delete_project_task(project_task)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_project_task!(project_task.id) end
    end

    test "change_project_task/1 returns a project_task changeset" do
      project_task = project_task_fixture()
      assert %Ecto.Changeset{} = Generic.change_project_task(project_task)
    end
  end

  describe "users" do
    alias AuditorActivity.Generic.User

    @valid_attrs %{active_status: true, email: "some email", first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{active_status: false, email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{active_status: nil, email: nil, first_name: nil, last_name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Generic.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Generic.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Generic.create_user(@valid_attrs)
      assert user.active_status == true
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Generic.update_user(user, @update_attrs)
      assert user.active_status == false
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_user(user, @invalid_attrs)
      assert user == Generic.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Generic.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Generic.change_user(user)
    end
  end

  describe "user_tasks" do
    alias AuditorActivity.Generic.UserProject

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_tasks_fixture(attrs \\ %{}) do
      {:ok, user_tasks} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_user_tasks()

      user_tasks
    end

    test "list_user_tasks/0 returns all user_tasks" do
      user_tasks = user_tasks_fixture()
      assert Generic.list_user_tasks() == [user_tasks]
    end

    test "get_user_tasks!/1 returns the user_tasks with given id" do
      user_tasks = user_tasks_fixture()
      assert Generic.get_user_tasks!(user_tasks.id) == user_tasks
    end

    test "create_user_tasks/1 with valid data creates a user_tasks" do
      assert {:ok, %UserProject{} = user_tasks} = Generic.create_user_tasks(@valid_attrs)
    end

    test "create_user_tasks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_user_tasks(@invalid_attrs)
    end

    test "update_user_tasks/2 with valid data updates the user_tasks" do
      user_tasks = user_tasks_fixture()
      assert {:ok, %UserProject{} = user_tasks} = Generic.update_user_tasks(user_tasks, @update_attrs)
    end

    test "update_user_tasks/2 with invalid data returns error changeset" do
      user_tasks = user_tasks_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_user_tasks(user_tasks, @invalid_attrs)
      assert user_tasks == Generic.get_user_tasks!(user_tasks.id)
    end

    test "delete_user_tasks/1 deletes the user_tasks" do
      user_tasks = user_tasks_fixture()
      assert {:ok, %UserProject{}} = Generic.delete_user_tasks(user_tasks)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_user_tasks!(user_tasks.id) end
    end

    test "change_user_tasks/1 returns a user_tasks changeset" do
      user_tasks = user_tasks_fixture()
      assert %Ecto.Changeset{} = Generic.change_user_tasks(user_tasks)
    end
  end

  describe "user_tasks" do
    alias AuditorActivity.Generic.UserTask

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_task_fixture(attrs \\ %{}) do
      {:ok, user_task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_user_task()

      user_task
    end

    test "list_user_tasks/0 returns all user_tasks" do
      user_task = user_task_fixture()
      assert Generic.list_user_tasks() == [user_task]
    end

    test "get_user_task!/1 returns the user_task with given id" do
      user_task = user_task_fixture()
      assert Generic.get_user_task!(user_task.id) == user_task
    end

    test "create_user_task/1 with valid data creates a user_task" do
      assert {:ok, %UserTask{} = user_task} = Generic.create_user_task(@valid_attrs)
    end

    test "create_user_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_user_task(@invalid_attrs)
    end

    test "update_user_task/2 with valid data updates the user_task" do
      user_task = user_task_fixture()
      assert {:ok, %UserTask{} = user_task} = Generic.update_user_task(user_task, @update_attrs)
    end

    test "update_user_task/2 with invalid data returns error changeset" do
      user_task = user_task_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_user_task(user_task, @invalid_attrs)
      assert user_task == Generic.get_user_task!(user_task.id)
    end

    test "delete_user_task/1 deletes the user_task" do
      user_task = user_task_fixture()
      assert {:ok, %UserTask{}} = Generic.delete_user_task(user_task)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_user_task!(user_task.id) end
    end

    test "change_user_task/1 returns a user_task changeset" do
      user_task = user_task_fixture()
      assert %Ecto.Changeset{} = Generic.change_user_task(user_task)
    end
  end

  describe "equipments" do
    alias AuditorActivity.Generic.Equipment

    @valid_attrs %{" name": "some  name", brand_name: "some brand_name", serial_no: "some serial_no"}
    @update_attrs %{" name": "some updated  name", brand_name: "some updated brand_name", serial_no: "some updated serial_no"}
    @invalid_attrs %{" name": nil, brand_name: nil, serial_no: nil}

    def equipment_fixture(attrs \\ %{}) do
      {:ok, equipment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_equipment()

      equipment
    end

    test "list_equipments/0 returns all equipments" do
      equipment = equipment_fixture()
      assert Generic.list_equipments() == [equipment]
    end

    test "get_equipment!/1 returns the equipment with given id" do
      equipment = equipment_fixture()
      assert Generic.get_equipment!(equipment.id) == equipment
    end

    test "create_equipment/1 with valid data creates a equipment" do
      assert {:ok, %Equipment{} = equipment} = Generic.create_equipment(@valid_attrs)
      assert equipment. name == "some  name"
      assert equipment.brand_name == "some brand_name"
      assert equipment.serial_no == "some serial_no"
    end

    test "create_equipment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_equipment(@invalid_attrs)
    end

    test "update_equipment/2 with valid data updates the equipment" do
      equipment = equipment_fixture()
      assert {:ok, %Equipment{} = equipment} = Generic.update_equipment(equipment, @update_attrs)
      assert equipment. name == "some updated  name"
      assert equipment.brand_name == "some updated brand_name"
      assert equipment.serial_no == "some updated serial_no"
    end

    test "update_equipment/2 with invalid data returns error changeset" do
      equipment = equipment_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_equipment(equipment, @invalid_attrs)
      assert equipment == Generic.get_equipment!(equipment.id)
    end

    test "delete_equipment/1 deletes the equipment" do
      equipment = equipment_fixture()
      assert {:ok, %Equipment{}} = Generic.delete_equipment(equipment)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_equipment!(equipment.id) end
    end

    test "change_equipment/1 returns a equipment changeset" do
      equipment = equipment_fixture()
      assert %Ecto.Changeset{} = Generic.change_equipment(equipment)
    end
  end

  describe "work_order_tasks" do
    alias AuditorActivity.Generic.WorkOrderTask

    @valid_attrs %{completed_on: "2010-04-17T14:00:00Z", end_date: ~D[2010-04-17], start_date: ~D[2010-04-17], started_on: "2010-04-17T14:00:00Z", status: "some status", time_to_finish: "2010-04-17T14:00:00Z"}
    @update_attrs %{completed_on: "2011-05-18T15:01:01Z", end_date: ~D[2011-05-18], start_date: ~D[2011-05-18], started_on: "2011-05-18T15:01:01Z", status: "some updated status", time_to_finish: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{completed_on: nil, end_date: nil, start_date: nil, started_on: nil, status: nil, time_to_finish: nil}

    def work_order_task_fixture(attrs \\ %{}) do
      {:ok, work_order_task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_work_order_task()

      work_order_task
    end

    test "list_work_order_tasks/0 returns all work_order_tasks" do
      work_order_task = work_order_task_fixture()
      assert Generic.list_work_order_tasks() == [work_order_task]
    end

    test "get_work_order_task!/1 returns the work_order_task with given id" do
      work_order_task = work_order_task_fixture()
      assert Generic.get_work_order_task!(work_order_task.id) == work_order_task
    end

    test "create_work_order_task/1 with valid data creates a work_order_task" do
      assert {:ok, %WorkOrderTask{} = work_order_task} = Generic.create_work_order_task(@valid_attrs)
      assert work_order_task.completed_on == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert work_order_task.end_date == ~D[2010-04-17]
      assert work_order_task.start_date == ~D[2010-04-17]
      assert work_order_task.started_on == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert work_order_task.status == "some status"
      assert work_order_task.time_to_finish == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_work_order_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_work_order_task(@invalid_attrs)
    end

    test "update_work_order_task/2 with valid data updates the work_order_task" do
      work_order_task = work_order_task_fixture()
      assert {:ok, %WorkOrderTask{} = work_order_task} = Generic.update_work_order_task(work_order_task, @update_attrs)
      assert work_order_task.completed_on == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert work_order_task.end_date == ~D[2011-05-18]
      assert work_order_task.start_date == ~D[2011-05-18]
      assert work_order_task.started_on == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert work_order_task.status == "some updated status"
      assert work_order_task.time_to_finish == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_work_order_task/2 with invalid data returns error changeset" do
      work_order_task = work_order_task_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_work_order_task(work_order_task, @invalid_attrs)
      assert work_order_task == Generic.get_work_order_task!(work_order_task.id)
    end

    test "delete_work_order_task/1 deletes the work_order_task" do
      work_order_task = work_order_task_fixture()
      assert {:ok, %WorkOrderTask{}} = Generic.delete_work_order_task(work_order_task)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_work_order_task!(work_order_task.id) end
    end

    test "change_work_order_task/1 returns a work_order_task changeset" do
      work_order_task = work_order_task_fixture()
      assert %Ecto.Changeset{} = Generic.change_work_order_task(work_order_task)
    end
  end

  describe "work_order_checklist" do
    alias AuditorActivity.Generic.WorkOrderChecklist

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def work_order_checklist_fixture(attrs \\ %{}) do
      {:ok, work_order_checklist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_work_order_checklist()

      work_order_checklist
    end

    test "list_work_order_checklist/0 returns all work_order_checklist" do
      work_order_checklist = work_order_checklist_fixture()
      assert Generic.list_work_order_checklist() == [work_order_checklist]
    end

    test "get_work_order_checklist!/1 returns the work_order_checklist with given id" do
      work_order_checklist = work_order_checklist_fixture()
      assert Generic.get_work_order_checklist!(work_order_checklist.id) == work_order_checklist
    end

    test "create_work_order_checklist/1 with valid data creates a work_order_checklist" do
      assert {:ok, %WorkOrderChecklist{} = work_order_checklist} = Generic.create_work_order_checklist(@valid_attrs)
      assert work_order_checklist.status == "some status"
    end

    test "create_work_order_checklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_work_order_checklist(@invalid_attrs)
    end

    test "update_work_order_checklist/2 with valid data updates the work_order_checklist" do
      work_order_checklist = work_order_checklist_fixture()
      assert {:ok, %WorkOrderChecklist{} = work_order_checklist} = Generic.update_work_order_checklist(work_order_checklist, @update_attrs)
      assert work_order_checklist.status == "some updated status"
    end

    test "update_work_order_checklist/2 with invalid data returns error changeset" do
      work_order_checklist = work_order_checklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_work_order_checklist(work_order_checklist, @invalid_attrs)
      assert work_order_checklist == Generic.get_work_order_checklist!(work_order_checklist.id)
    end

    test "delete_work_order_checklist/1 deletes the work_order_checklist" do
      work_order_checklist = work_order_checklist_fixture()
      assert {:ok, %WorkOrderChecklist{}} = Generic.delete_work_order_checklist(work_order_checklist)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_work_order_checklist!(work_order_checklist.id) end
    end

    test "change_work_order_checklist/1 returns a work_order_checklist changeset" do
      work_order_checklist = work_order_checklist_fixture()
      assert %Ecto.Changeset{} = Generic.change_work_order_checklist(work_order_checklist)
    end
  end

  describe "work_order_checkpoint" do
    alias AuditorActivity.Generic.WorkOrderCheckpoint

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def work_order_checkpoint_fixture(attrs \\ %{}) do
      {:ok, work_order_checkpoint} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_work_order_checkpoint()

      work_order_checkpoint
    end

    test "list_work_order_checkpoint/0 returns all work_order_checkpoint" do
      work_order_checkpoint = work_order_checkpoint_fixture()
      assert Generic.list_work_order_checkpoint() == [work_order_checkpoint]
    end

    test "get_work_order_checkpoint!/1 returns the work_order_checkpoint with given id" do
      work_order_checkpoint = work_order_checkpoint_fixture()
      assert Generic.get_work_order_checkpoint!(work_order_checkpoint.id) == work_order_checkpoint
    end

    test "create_work_order_checkpoint/1 with valid data creates a work_order_checkpoint" do
      assert {:ok, %WorkOrderCheckpoint{} = work_order_checkpoint} = Generic.create_work_order_checkpoint(@valid_attrs)
      assert work_order_checkpoint.status == "some status"
    end

    test "create_work_order_checkpoint/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_work_order_checkpoint(@invalid_attrs)
    end

    test "update_work_order_checkpoint/2 with valid data updates the work_order_checkpoint" do
      work_order_checkpoint = work_order_checkpoint_fixture()
      assert {:ok, %WorkOrderCheckpoint{} = work_order_checkpoint} = Generic.update_work_order_checkpoint(work_order_checkpoint, @update_attrs)
      assert work_order_checkpoint.status == "some updated status"
    end

    test "update_work_order_checkpoint/2 with invalid data returns error changeset" do
      work_order_checkpoint = work_order_checkpoint_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_work_order_checkpoint(work_order_checkpoint, @invalid_attrs)
      assert work_order_checkpoint == Generic.get_work_order_checkpoint!(work_order_checkpoint.id)
    end

    test "delete_work_order_checkpoint/1 deletes the work_order_checkpoint" do
      work_order_checkpoint = work_order_checkpoint_fixture()
      assert {:ok, %WorkOrderCheckpoint{}} = Generic.delete_work_order_checkpoint(work_order_checkpoint)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_work_order_checkpoint!(work_order_checkpoint.id) end
    end

    test "change_work_order_checkpoint/1 returns a work_order_checkpoint changeset" do
      work_order_checkpoint = work_order_checkpoint_fixture()
      assert %Ecto.Changeset{} = Generic.change_work_order_checkpoint(work_order_checkpoint)
    end
  end

  describe "timezones" do
    alias AuditorActivity.Generic.Timezone

    @valid_attrs %{" city": "some  city", city_low: "some city_low", city_stripped: "some city_stripped", continent: "some continent", label: "some label", offset: "some offset", state: "some state", utc_offset_seconds: 42}
    @update_attrs %{" city": "some updated  city", city_low: "some updated city_low", city_stripped: "some updated city_stripped", continent: "some updated continent", label: "some updated label", offset: "some updated offset", state: "some updated state", utc_offset_seconds: 43}
    @invalid_attrs %{" city": nil, city_low: nil, city_stripped: nil, continent: nil, label: nil, offset: nil, state: nil, utc_offset_seconds: nil}

    def timezone_fixture(attrs \\ %{}) do
      {:ok, timezone} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_timezone()

      timezone
    end

    test "list_timezones/0 returns all timezones" do
      timezone = timezone_fixture()
      assert Generic.list_timezones() == [timezone]
    end

    test "get_timezone!/1 returns the timezone with given id" do
      timezone = timezone_fixture()
      assert Generic.get_timezone!(timezone.id) == timezone
    end

    test "create_timezone/1 with valid data creates a timezone" do
      assert {:ok, %Timezone{} = timezone} = Generic.create_timezone(@valid_attrs)
      assert timezone. city == "some  city"
      assert timezone.city_low == "some city_low"
      assert timezone.city_stripped == "some city_stripped"
      assert timezone.continent == "some continent"
      assert timezone.label == "some label"
      assert timezone.offset == "some offset"
      assert timezone.state == "some state"
      assert timezone.utc_offset_seconds == 42
    end

    test "create_timezone/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_timezone(@invalid_attrs)
    end

    test "update_timezone/2 with valid data updates the timezone" do
      timezone = timezone_fixture()
      assert {:ok, %Timezone{} = timezone} = Generic.update_timezone(timezone, @update_attrs)
      assert timezone. city == "some updated  city"
      assert timezone.city_low == "some updated city_low"
      assert timezone.city_stripped == "some updated city_stripped"
      assert timezone.continent == "some updated continent"
      assert timezone.label == "some updated label"
      assert timezone.offset == "some updated offset"
      assert timezone.state == "some updated state"
      assert timezone.utc_offset_seconds == 43
    end

    test "update_timezone/2 with invalid data returns error changeset" do
      timezone = timezone_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_timezone(timezone, @invalid_attrs)
      assert timezone == Generic.get_timezone!(timezone.id)
    end

    test "delete_timezone/1 deletes the timezone" do
      timezone = timezone_fixture()
      assert {:ok, %Timezone{}} = Generic.delete_timezone(timezone)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_timezone!(timezone.id) end
    end

    test "change_timezone/1 returns a timezone changeset" do
      timezone = timezone_fixture()
      assert %Ecto.Changeset{} = Generic.change_timezone(timezone)
    end
  end

  describe "equipment_categories" do
    alias AuditorActivity.Generic.Equipment_Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def equipment_category_fixture(attrs \\ %{}) do
      {:ok, equipment_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_equipment_category()

      equipment_category
    end

    test "list_equipment_categories/0 returns all equipment_categories" do
      equipment_category = equipment_category_fixture()
      assert Generic.list_equipment_categories() == [equipment_category]
    end

    test "get_equipment_category!/1 returns the equipment_category with given id" do
      equipment_category = equipment_category_fixture()
      assert Generic.get_equipment_category!(equipment_category.id) == equipment_category
    end

    test "create_equipment_category/1 with valid data creates a equipment_category" do
      assert {:ok, %Equipment_Category{} = equipment_category} = Generic.create_equipment_category(@valid_attrs)
      assert equipment_category.name == "some name"
    end

    test "create_equipment_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_equipment_category(@invalid_attrs)
    end

    test "update_equipment_category/2 with valid data updates the equipment_category" do
      equipment_category = equipment_category_fixture()
      assert {:ok, %Equipment_Category{} = equipment_category} = Generic.update_equipment_category(equipment_category, @update_attrs)
      assert equipment_category.name == "some updated name"
    end

    test "update_equipment_category/2 with invalid data returns error changeset" do
      equipment_category = equipment_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_equipment_category(equipment_category, @invalid_attrs)
      assert equipment_category == Generic.get_equipment_category!(equipment_category.id)
    end

    test "delete_equipment_category/1 deletes the equipment_category" do
      equipment_category = equipment_category_fixture()
      assert {:ok, %Equipment_Category{}} = Generic.delete_equipment_category(equipment_category)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_equipment_category!(equipment_category.id) end
    end

    test "change_equipment_category/1 returns a equipment_category changeset" do
      equipment_category = equipment_category_fixture()
      assert %Ecto.Changeset{} = Generic.change_equipment_category(equipment_category)
    end
  end

  describe "equipment_categories" do
    alias AuditorActivity.Generic.EquipmentCategory

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def equipment_category_fixture(attrs \\ %{}) do
      {:ok, equipment_category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_equipment_category()

      equipment_category
    end

    test "list_equipment_categories/0 returns all equipment_categories" do
      equipment_category = equipment_category_fixture()
      assert Generic.list_equipment_categories() == [equipment_category]
    end

    test "get_equipment_category!/1 returns the equipment_category with given id" do
      equipment_category = equipment_category_fixture()
      assert Generic.get_equipment_category!(equipment_category.id) == equipment_category
    end

    test "create_equipment_category/1 with valid data creates a equipment_category" do
      assert {:ok, %EquipmentCategory{} = equipment_category} = Generic.create_equipment_category(@valid_attrs)
      assert equipment_category.name == "some name"
    end

    test "create_equipment_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_equipment_category(@invalid_attrs)
    end

    test "update_equipment_category/2 with valid data updates the equipment_category" do
      equipment_category = equipment_category_fixture()
      assert {:ok, %EquipmentCategory{} = equipment_category} = Generic.update_equipment_category(equipment_category, @update_attrs)
      assert equipment_category.name == "some updated name"
    end

    test "update_equipment_category/2 with invalid data returns error changeset" do
      equipment_category = equipment_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_equipment_category(equipment_category, @invalid_attrs)
      assert equipment_category == Generic.get_equipment_category!(equipment_category.id)
    end

    test "delete_equipment_category/1 deletes the equipment_category" do
      equipment_category = equipment_category_fixture()
      assert {:ok, %EquipmentCategory{}} = Generic.delete_equipment_category(equipment_category)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_equipment_category!(equipment_category.id) end
    end

    test "change_equipment_category/1 returns a equipment_category changeset" do
      equipment_category = equipment_category_fixture()
      assert %Ecto.Changeset{} = Generic.change_equipment_category(equipment_category)
    end
  end

  describe "teams" do
    alias AuditorActivity.Generic.Team

    @valid_attrs %{name: "some name", user_count: 42}
    @update_attrs %{name: "some updated name", user_count: 43}
    @invalid_attrs %{name: nil, user_count: nil}

    def team_fixture(attrs \\ %{}) do
      {:ok, team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_team()

      team
    end

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Generic.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Generic.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      assert {:ok, %Team{} = team} = Generic.create_team(@valid_attrs)
      assert team.name == "some name"
      assert team.user_count == 42
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      assert {:ok, %Team{} = team} = Generic.update_team(team, @update_attrs)
      assert team.name == "some updated name"
      assert team.user_count == 43
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_team(team, @invalid_attrs)
      assert team == Generic.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Generic.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Generic.change_team(team)
    end
  end

  describe "team_users" do
    alias AuditorActivity.Generic.TeamUser

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def team_user_fixture(attrs \\ %{}) do
      {:ok, team_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_team_user()

      team_user
    end

    test "list_team_users/0 returns all team_users" do
      team_user = team_user_fixture()
      assert Generic.list_team_users() == [team_user]
    end

    test "get_team_user!/1 returns the team_user with given id" do
      team_user = team_user_fixture()
      assert Generic.get_team_user!(team_user.id) == team_user
    end

    test "create_team_user/1 with valid data creates a team_user" do
      assert {:ok, %TeamUser{} = team_user} = Generic.create_team_user(@valid_attrs)
    end

    test "create_team_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_team_user(@invalid_attrs)
    end

    test "update_team_user/2 with valid data updates the team_user" do
      team_user = team_user_fixture()
      assert {:ok, %TeamUser{} = team_user} = Generic.update_team_user(team_user, @update_attrs)
    end

    test "update_team_user/2 with invalid data returns error changeset" do
      team_user = team_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_team_user(team_user, @invalid_attrs)
      assert team_user == Generic.get_team_user!(team_user.id)
    end

    test "delete_team_user/1 deletes the team_user" do
      team_user = team_user_fixture()
      assert {:ok, %TeamUser{}} = Generic.delete_team_user(team_user)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_team_user!(team_user.id) end
    end

    test "change_team_user/1 returns a team_user changeset" do
      team_user = team_user_fixture()
      assert %Ecto.Changeset{} = Generic.change_team_user(team_user)

  describe "skills" do
    alias AuditorActivity.Generic.Skill

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def skill_fixture(attrs \\ %{}) do
      {:ok, skill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_skill()

      skill
    end

    test "list_skills/0 returns all skills" do
      skill = skill_fixture()
      assert Generic.list_skills() == [skill]
    end

    test "get_skill!/1 returns the skill with given id" do
      skill = skill_fixture()
      assert Generic.get_skill!(skill.id) == skill
    end

    test "create_skill/1 with valid data creates a skill" do
      assert {:ok, %Skill{} = skill} = Generic.create_skill(@valid_attrs)
      assert skill.name == "some name"
    end

    test "create_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_skill(@invalid_attrs)
    end

    test "update_skill/2 with valid data updates the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{} = skill} = Generic.update_skill(skill, @update_attrs)
      assert skill.name == "some updated name"
    end

    test "update_skill/2 with invalid data returns error changeset" do
      skill = skill_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_skill(skill, @invalid_attrs)
      assert skill == Generic.get_skill!(skill.id)
    end

    test "delete_skill/1 deletes the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{}} = Generic.delete_skill(skill)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_skill!(skill.id) end
    end

    test "change_skill/1 returns a skill changeset" do
      skill = skill_fixture()
      assert %Ecto.Changeset{} = Generic.change_skill(skill)
    end
  end


  describe "team_skills" do
    alias AuditorActivity.Generic.TeamSkill


    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def team_skill_fixture(attrs \\ %{}) do
      {:ok, team_skill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_team_skill()

      team_skill
    end

    test "list_team_skills/0 returns all team_skills" do
      team_skill = team_skill_fixture()
      assert Generic.list_team_skills() == [team_skill]
    end

    test "get_team_skill!/1 returns the team_skill with given id" do
      team_skill = team_skill_fixture()
      assert Generic.get_team_skill!(team_skill.id) == team_skill
    end

    test "create_team_skill/1 with valid data creates a team_skill" do
      assert {:ok, %TeamSkill{} = team_skill} = Generic.create_team_skill(@valid_attrs)
    end

    test "create_team_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_team_skill(@invalid_attrs)
    end

    test "update_team_skill/2 with valid data updates the team_skill" do
      team_skill = team_skill_fixture()
      assert {:ok, %TeamSkill{} = team_skill} = Generic.update_team_skill(team_skill, @update_attrs)
    end

    test "update_team_skill/2 with invalid data returns error changeset" do
      team_skill = team_skill_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_team_skill(team_skill, @invalid_attrs)
      assert team_skill == Generic.get_team_skill!(team_skill.id)
    end

    test "delete_team_skill/1 deletes the team_skill" do
      team_skill = team_skill_fixture()
      assert {:ok, %TeamSkill{}} = Generic.delete_team_skill(team_skill)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_team_skill!(team_skill.id) end
    end

    test "change_team_skill/1 returns a team_skill changeset" do
      team_skill = team_skill_fixture()
      assert %Ecto.Changeset{} = Generic.change_team_skill(team_skill)
    end
  end

  describe "team_templates" do
    alias AuditorActivity.Generic.TeamTemplate

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def team_template_fixture(attrs \\ %{}) do
      {:ok, team_template} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_team_template()

      team_template
    end

    test "list_team_templates/0 returns all team_templates" do
      team_template = team_template_fixture()
      assert Generic.list_team_templates() == [team_template]
    end

    test "get_team_template!/1 returns the team_template with given id" do
      team_template = team_template_fixture()
      assert Generic.get_team_template!(team_template.id) == team_template
    end

    test "create_team_template/1 with valid data creates a team_template" do
      assert {:ok, %TeamTemplate{} = team_template} = Generic.create_team_template(@valid_attrs)
      assert team_template.description == "some description"
      assert team_template.name == "some name"
    end

    test "create_team_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_team_template(@invalid_attrs)
    end

    test "update_team_template/2 with valid data updates the team_template" do
      team_template = team_template_fixture()
      assert {:ok, %TeamTemplate{} = team_template} = Generic.update_team_template(team_template, @update_attrs)
      assert team_template.description == "some updated description"
      assert team_template.name == "some updated name"
    end

    test "update_team_template/2 with invalid data returns error changeset" do
      team_template = team_template_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_team_template(team_template, @invalid_attrs)
      assert team_template == Generic.get_team_template!(team_template.id)
    end

    test "delete_team_template/1 deletes the team_template" do
      team_template = team_template_fixture()
      assert {:ok, %TeamTemplate{}} = Generic.delete_team_template(team_template)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_team_template!(team_template.id) end
    end

    test "change_team_template/1 returns a team_template changeset" do
      team_template = team_template_fixture()
      assert %Ecto.Changeset{} = Generic.change_team_template(team_template)

      describe "user_skills" do
        alias AuditorActivity.Generic.UserSkill

    def user_skill_fixture(attrs \\ %{}) do
      {:ok, user_skill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_user_skill()

      user_skill
    end

    test "list_user_skills/0 returns all user_skills" do
      user_skill = user_skill_fixture()
      assert Generic.list_user_skills() == [user_skill]
    end

    test "get_user_skill!/1 returns the user_skill with given id" do
      user_skill = user_skill_fixture()
      assert Generic.get_user_skill!(user_skill.id) == user_skill
    end

    test "create_user_skill/1 with valid data creates a user_skill" do
      assert {:ok, %UserSkill{} = user_skill} = Generic.create_user_skill(@valid_attrs)
    end

    test "create_user_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_user_skill(@invalid_attrs)
    end

    test "update_user_skill/2 with valid data updates the user_skill" do
      user_skill = user_skill_fixture()
      assert {:ok, %UserSkill{} = user_skill} = Generic.update_user_skill(user_skill, @update_attrs)
    end

    test "update_user_skill/2 with invalid data returns error changeset" do
      user_skill = user_skill_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_user_skill(user_skill, @invalid_attrs)
      assert user_skill == Generic.get_user_skill!(user_skill.id)
    end

    test "delete_user_skill/1 deletes the user_skill" do
      user_skill = user_skill_fixture()
      assert {:ok, %UserSkill{}} = Generic.delete_user_skill(user_skill)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_user_skill!(user_skill.id) end
    end

    test "change_user_skill/1 returns a user_skill changeset" do
      user_skill = user_skill_fixture()
      assert %Ecto.Changeset{} = Generic.change_user_skill(user_skill)
    end
  end

  describe "shift_times" do
    alias AuditorActivity.Generic.ShiftTime

    @valid_attrs %{" name": "some  name", end_time: ~T[14:00:00], start_time: ~T[14:00:00]}
    @update_attrs %{" name": "some updated  name", end_time: ~T[15:01:01], start_time: ~T[15:01:01]}
    @invalid_attrs %{" name": nil, end_time: nil, start_time: nil}

    def shift_time_fixture(attrs \\ %{}) do
      {:ok, shift_time} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_shift_time()

      shift_time
    end

    test "list_shift_times/0 returns all shift_times" do
      shift_time = shift_time_fixture()
      assert Generic.list_shift_times() == [shift_time]
    end

    test "get_shift_time!/1 returns the shift_time with given id" do
      shift_time = shift_time_fixture()
      assert Generic.get_shift_time!(shift_time.id) == shift_time
    end

    test "create_shift_time/1 with valid data creates a shift_time" do
      assert {:ok, %ShiftTime{} = shift_time} = Generic.create_shift_time(@valid_attrs)
      assert shift_time. name == "some  name"
      assert shift_time.end_time == ~T[14:00:00]
      assert shift_time.start_time == ~T[14:00:00]
    end

    test "create_shift_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_shift_time(@invalid_attrs)
    end

    test "update_shift_time/2 with valid data updates the shift_time" do
      shift_time = shift_time_fixture()
      assert {:ok, %ShiftTime{} = shift_time} = Generic.update_shift_time(shift_time, @update_attrs)
      assert shift_time. name == "some updated  name"
      assert shift_time.end_time == ~T[15:01:01]
      assert shift_time.start_time == ~T[15:01:01]
    end

    test "update_shift_time/2 with invalid data returns error changeset" do
      shift_time = shift_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_shift_time(shift_time, @invalid_attrs)
      assert shift_time == Generic.get_shift_time!(shift_time.id)
    end

    test "delete_shift_time/1 deletes the shift_time" do
      shift_time = shift_time_fixture()
      assert {:ok, %ShiftTime{}} = Generic.delete_shift_time(shift_time)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_shift_time!(shift_time.id) end
    end

    test "change_shift_time/1 returns a shift_time changeset" do
      shift_time = shift_time_fixture()
      assert %Ecto.Changeset{} = Generic.change_shift_time(shift_time)
    end
  end

  describe "skills" do
    alias AuditorActivity.Generic.Skill

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def skill_fixture(attrs \\ %{}) do
      {:ok, skill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Generic.create_skill()

      skill
    end

    test "list_skills/0 returns all skills" do
      skill = skill_fixture()
      assert Generic.list_skills() == [skill]
    end

    test "get_skill!/1 returns the skill with given id" do
      skill = skill_fixture()
      assert Generic.get_skill!(skill.id) == skill
    end

    test "create_skill/1 with valid data creates a skill" do
      assert {:ok, %Skill{} = skill} = Generic.create_skill(@valid_attrs)
    end

    test "create_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Generic.create_skill(@invalid_attrs)
    end

    test "update_skill/2 with valid data updates the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{} = skill} = Generic.update_skill(skill, @update_attrs)
    end

    test "update_skill/2 with invalid data returns error changeset" do
      skill = skill_fixture()
      assert {:error, %Ecto.Changeset{}} = Generic.update_skill(skill, @invalid_attrs)
      assert skill == Generic.get_skill!(skill.id)
    end

    test "delete_skill/1 deletes the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{}} = Generic.delete_skill(skill)
      assert_raise Ecto.NoResultsError, fn -> Generic.get_skill!(skill.id) end
    end

    test "change_skill/1 returns a skill changeset" do
      skill = skill_fixture()
      assert %Ecto.Changeset{} = Generic.change_skill(skill)
    end
  end
end
