using Gtk

#Create the main window
win  = GtkWindow("Calculator", 200, 200)

#vetical layout box
vbox = GtkBox(:v, spacing = 5)
push!(win, vbox)

#Display Entry
display = GtkEntry()
set_gtk_property!(display, :editable, false)
set_gtk_property!(display, :height_request, 40)
set_gtk_property!(display, :text, "")
push!(vbox, display)

#Buttons labels (rows of buttons)
buttons = [
    ["C", "(", ")", ""],
    ["7", "8", "9", "+"],
    ["4", "5", "6", "-"],
    ["1", "2", "3", "*"],
    ["0", ".", "=", "/"]
    
]

#Append text to the display
function append_display(text)
    current = get_gtk_property(display, :text, String)
    set_gtk_property!(display, :text, current * text)
end

#Clear the display
function clear_display()
    set_gtk_property!(display, :text, "")
end

#Evaluate the expression and show result
function evaluate_expression()
    expStr = get_gtk_property(display, :text, String)
    try
        result = eval(Meta.parse(expStr))
        set_gtk_property!(display, :text, string(result))
    catch e
        set_gtk_property!(display, :text, string(e))
    end
end

#Button click Handler
function on_button_clicked(widget)
    label = get_gtk_property(widget, :label, String)
    if label == "="
        evaluate_expression()
    elseif label == "C"
        clear_display()
    else
        append_display(label)
    end
end

#Create buttons and add items to the layout
for rowLabels in buttons
    hbox = GtkBox(:h, spacing=5)
    for label in rowLabels
        if label != ""
            button = GtkButton(label)
            signal_connect(button, "clicked") do widget on_button_clicked(widget) end
            push!(hbox, button)
        end
    end
    push!(vbox, hbox)
end

#show everything
showall(win)
Gtk.gtk_main()