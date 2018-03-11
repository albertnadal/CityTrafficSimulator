With Tipus; use Tipus;
package QueueArray is
    type Queue is limited private;

    type Pqueue is access Queue;
    
    procedure Enqueue ( X: Item; Q: in out pqueue );
    procedure Dequeue ( X: out Item; Buit: out Boolean; EnEspera: out Integer; Q: in out pqueue );
    function  Is_Empty( Q: pqueue ) return Boolean;
    function  Is_Full ( Q: pqueue ) return Boolean;
    procedure Make_Empty( Q: in out pqueue );

    Overflow : exception;
    Underflow: exception;

    private
       
    type Array_Of_Element_Type is array( Positive range <> ) of Item;
    
    protected type Queue is
       
       procedure Enqueue ( X: Item);
       procedure Dequeue ( X: out Item; EnEspera: out Integer);
       function  Is_Empty return Boolean;
       function  Is_Full return Boolean;
       procedure Make_Empty;

    private
         Q_Front    : Natural := 1;
         Q_Rear     : Natural := 0;
         Q_Size     : Natural := 0;
         Q_Array	  : Array_Of_Element_Type( 1..1000 );
    end Queue;
    
end QueueArray;
