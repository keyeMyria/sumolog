<?php 

namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use \Serverfireteam\Panel\CrudController;

use Illuminate\Http\Request;

class SmokeController extends CrudController{

    public function all($entity){
        parent::all($entity);

			$this->filter = \DataFilter::source(new \App\Smoke());
			$this->filter->add('user_id', 'User ID', 'text');
			$this->filter->submit('search');
			$this->filter->reset('reset');
			$this->filter->build();

			$this->grid = \DataGrid::source($this->filter);
			$this->grid->add('user_id', 'User ID');
			$this->grid->add('started_at', 'Started_at');
            $this->grid->add('ended_at', 'Ended_at');
			$this->addStylesToGrid();
                 
        return $this->returnView();
    }
    
    public function  edit($entity){
        
        parent::edit($entity);

			$this->edit = \DataEdit::source(new \App\Smoke());
			$this->edit->label('Edit Smoke');

			$this->edit->add('user_id', 'User ID', 'number')->rule('required')->rule('exists:users,id');
            $this->edit->add('ended_at', 'Ended_at', 'date')->format('Y/m/d', 'ja');

        return $this->returnEditView();
    }    
}
