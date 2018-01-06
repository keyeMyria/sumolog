<?php 

namespace App\Http\Controllers;

use App\Http\Requests;
use \Serverfireteam\Panel\CrudController;

class UserController extends CrudController{

    public function all($entity){
        parent::all($entity);
        $this->filter = \DataFilter::source(new \App\User());
        $this->filter->add('uuid', 'UUID', 'text');
        $this->filter->add('created_at', 'Created_at', 'text');
        $this->filter->add('updated_at', 'Updated_at', 'text');
        $this->filter->add('payday', 'PayDay', 'number');
        $this->filter->add('Price', 'price', 'number');
        $this->filter->add('target_number', 'Target Number', 'number');
        $this->filter->add('one_box_number', 'One Box Number', 'number');

        $this->filter->submit('search');
        $this->filter->reset('reset');
        $this->filter->build();

        $this->grid = \DataGrid::source($this->filter);
        $this->grid->add('id', 'ID', true);
        $this->grid->add('uuid', 'UUID');
        $this->grid->add('created_at', 'Created_at', true);
        $this->grid->add('updated_at', 'Updated_at', true);
        $this->grid->add('payday', 'PayDay', true);
        $this->grid->add('price', 'Price', true);
        $this->grid->add('one_box_number', 'One Box Number', true);
        $this->grid->add('target_number', 'Target Number', true);
        $this->grid->add('address', 'Address', true);
        $this->addStylesToGrid();

        return $this->returnView();
    }
    
    public function  edit($entity){
        
        parent::edit($entity);

        $this->edit = \DataEdit::source(new \App\User());
        $this->edit->label('Edit User');

        $this->edit->add('uuid', 'UUID', 'text')->rule('required');
        $this->edit->add('payday', 'PayDay', 'number');
        $this->edit->add('price', 'Price', 'number');
        $this->edit->add('one_box_number', 'One Box Number', 'number');
        $this->edit->add('target_number', 'Target Number', 'number');
        $this->edit->add('address', 'Address', 'text');

        return $this->returnEditView();
    }    
}
