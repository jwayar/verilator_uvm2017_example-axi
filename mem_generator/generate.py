import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import os

# Estructura de datos unificada para los registros
REGISTROS = [
    {"addr": "01C", "name": "GIE", "desc": "Global Interrupt Enable Register"},
    {"addr": "020", "name": "ISR", "desc": "Interrupt Status Register"},
    {"addr": "028", "name": "IER", "desc": "Interrupt Enable Register"},
    {"addr": "040", "name": "SOFTR", "desc": "Soft Reset Register"},
    {"addr": "100", "name": "CR", "desc": "Control Register"},
    {"addr": "104", "name": "SR", "desc": "Status Register"},
    {"addr": "108", "name": "TX_FIFO", "desc": "Transmit FIFO Register"},
    {"addr": "10C", "name": "RX_FIFO", "desc": "Receive FIFO Register"},
    {"addr": "110", "name": "ADR", "desc": "Slave Address Register"},
    {"addr": "114", "name": "TX_FIFO_OCY", "desc": "Transmit FIFO Occupancy Register"},
    {"addr": "118", "name": "RX_FIFO_OCY", "desc": "Receive FIFO Occupancy Register"},
    {"addr": "11C", "name": "TEN_ADR", "desc": "Slave Ten Bit Address Register"},
    {"addr": "120", "name": "RX_FIFO_PIRQ", "desc": "Receive FIFO Programmable Depth Interrupt Register"},
    {"addr": "124", "name": "GPO", "desc": "General Purpose Output Register"},
    {"addr": "128", "name": "TSUSTA", "desc": "Timing Parameter Register"},
    {"addr": "12C", "name": "TSUSTO", "desc": "Timing Parameter Register"},
    {"addr": "130", "name": "THDSTA", "desc": "Timing Parameter Register"},
    {"addr": "134", "name": "TSUDAT", "desc": "Timing Parameter Register"},
    {"addr": "138", "name": "TBUF", "desc": "Timing Parameter Register"},
    {"addr": "13C", "name": "THIGH", "desc": "Timing Parameter Register"},
    {"addr": "140", "name": "TLOW", "desc": "Timing Parameter Register"},
    {"addr": "144", "name": "THDDAT", "desc": "Timing Parameter Register"},
]

# Diccionario de ayuda actualizado con el nuevo formato y datos
HELP_TEXT = {
    "01C": {
        "title": "GIE - Global Interrupt Enable Register",
        "bits": [
            ("31:1", "Reserved", "0", "R", "Reserved."),
            ("0", "GIE(0)", "0", "R/W", "Global Interrupt Enable. 1=Enabled, 0=Disabled.")
        ]
    },
    "020": {
        "title": "ISR - Interrupt Status Register (020h)",
        "bits": [
            ("31:8", "Reserved", "N/A", "N/A", "Reserved."),
            ("7", "Status int(7)", "1", "Read/Toggle on Write", "Transmit FIFO half empty."),
            ("6", "Status int(6)", "1", "Read/Toggle on Write", "Not addressed as slave."),
            ("5", "Status int(5)", "0", "Read/Toggle on Write", "Addressed as slave."),
            ("4", "Status int(4)", "1", "Read/Toggle on Write", "IIC bus not busy."),
            ("3", "Status int(3)", "0", "Read/Toggle on Write", "Receive FIFO full."),
            ("2", "Status int(2)", "0", "Read/Toggle on Write", "Transmit FIFO empty."),
            ("1", "Status int(1)", "0", "Read/Toggle on Write", "Transmit error / Slave transmit complete."),
            ("0", "Status int(0)", "0", "Read/Toggle on Write", "Arbitration lost.")
        ]
    },
    "028": {
        "title": "IER - Interrupt Enable Register",
        "bits": [
            ("31:8", "Reserved", "0", "R", "Reserved."),
            ("7", "Enable int(7)", "0", "R/W", "Transmit FIFO half empty."),
            ("6", "Enable int(6)", "0", "R/W", "Not addressed as slave."),
            ("5", "Enable int(5)", "0", "R/W", "Addressed as slave."),
            ("4", "Enable int(4)", "0", "R/W", "IIC bus not busy."),
            ("3", "Enable int(3)", "0", "R/W", "Receive FIFO full."),
            ("2", "Enable int(2)", "0", "R/W", "Transmit FIFO empty."),
            ("1", "Enable int(1)", "0", "R/W", "Transmit error / Slave transmit complete."),
            ("0", "Enable int(0)", "0", "R/W", "Arbitration lost.")
        ]
    },
    "040": {
        "title": "SOFTR - Soft-Reset Register",
        "bits": [
            ("31:8", "Reserved", "0", "R", "Reserved."),
            ("7:0", "Reset_Key", "0x00", "W", "Write 0x0A here to reset the core.")
        ]
    },
    "100": {
        "title": "CR - Control Register",
        "bits": [
            ("6", "GC_En", "0", "R/W", "General Call Enable. 1=Enabled."),
            ("5", "RSTA", "0", "W", "Repeated Start. Generates a REPEATED START condition (self-clearing)."),
            ("4", "TXAK", "0", "R/W", "Transmit Acknowledge. Determines the ACK bit to send."),
            ("3", "TX", "0", "R/W", "Transmit mode. 1=Transmit, 0=Receive."),
            ("2", "MS", "0", "R/W", "Master/Slave mode. 1=Master, 0=Slave."),
            ("1", "TX_FIFO_Reset", "0", "W", "Resets the transmit FIFO (self-clearing)."),
            ("0", "EN", "0", "R/W", "Enables the IIC core. 1=Enabled.")
        ]
    },
    "104": {
        "title": "SR - Status Register",
        "bits": [
            ("7", "RX_FIFO_Empty", "1", "R", "Receive FIFO is empty."),
            ("6", "TX_FIFO_Empty", "1", "R", "Transmit FIFO is empty."),
            ("5", "RX_FIFO_Full", "0", "R", "Receive FIFO is full."),
            ("4", "TX_FIFO_Full", "0", "R", "Transmit FIFO is full."),
            ("3", "SRW", "0", "R", "Slave Read/Write. Indicates the direction of the slave transfer (1=Read)."),
            ("2", "Bus_Busy", "0", "R", "IIC bus is currently busy."),
            ("1", "Addressed_As_Slave", "0", "R", "The core has been addressed as a slave."),
            ("0", "Arbitration_Lost", "0", "R", "Arbitration lost.")
        ]
    },
    "108": {
        "title": "TX_FIFO - Transmit FIFO",
        "bits": [
            ("7:0", "Data", "-", "W", "8-bit data to transmit.")
        ]
    },
    "10C": {
        "title": "RX_FIFO - Receive FIFO",
        "bits": [
            ("7:0", "Data", "-", "R", "8-bit received data.")
        ]
    },
    "114": {
        "title": "TX_FIFO_OCY - Transmit FIFO Occupancy",
        "bits": [
            ("31:4", "Reserved", "0", "R", "Reserved."),
            ("3:0", "Occupancy(3:0)", "0", "R", "Number of bytes currently in the transmit FIFO.")
        ]
    },
    "118": {
        "title": "RX_FIFO_OCY - Receive FIFO Occupancy",
        "bits": [
            ("31:4", "Reserved", "0", "R", "Reserved."),
            ("3:0", "Occupancy(3:0)", "0", "R", "Number of bytes currently in the receive FIFO.")
        ]
    },
    "120": {
        "title": "RX_FIFO_PIRQ - Receive FIFO Programmable Interrupt",
        "bits": [
            ("31:4", "Reserved", "0", "R", "Reserved."),
            ("3:0", "Threshold(3:0)", "0", "R/W", "Threshold to generate an interrupt when RX_FIFO occupancy is >= this value.")
        ]
    },
}


class MemGenApp:
    def recalculate_ok_err(self):
        total_rows = len(self.rows)
        for i, row in enumerate(self.rows):
            if row is not None:
                op_var, next_ok_var, next_err_var, reg_var, data_var, mask_var, col = row
                next_ok_var.set(f"{i+1:02X}" if i < total_rows - 1 else f"{i:02X}")
                next_err_var.set(f"{i:02X}")

    def __init__(self, root):
        self.root = root
        self.root.title("Generador de archivos .mem AXI/I2C")
        self.rows = []
        self.selected_rows_vars = []

        btn_frame = tk.Frame(self.root)
        btn_frame.grid(row=0, column=0, columnspan=20, sticky="nw", padx=5, pady=5)
        
        tk.Button(btn_frame, text="Agregar línea", command=self.add_row).pack(side="left", padx=2)
        tk.Button(btn_frame, text="Eliminar seleccionadas", command=self.delete_selected_rows).pack(side="left", padx=2)
        tk.Button(btn_frame, text="Generar archivos", command=self.generate_files).pack(side="left", padx=2)
        tk.Button(btn_frame, text="Importar .mem", command=self.import_mem_files).pack(side="left", padx=2)
        tk.Button(btn_frame, text="Ayuda", command=self.show_help_window).pack(side="left", padx=2)
        
        self.redraw_grid()
            
    def redraw_grid(self):
        for widget in self.root.grid_slaves():
            if int(widget.grid_info()["row"]) > 0:
                widget.destroy()

        headers = ["", "#", "W", "R", "Registro", "Dato", "Máscara", "Ok", "Err"]
        
        num_cols_to_display = 2 if len(self.rows) > 32 else 1

        for col in range(num_cols_to_display):
            base_col = col * 10 
            for i, h in enumerate(headers):
                lbl = tk.Label(self.root, text=h, font=("Arial", 10, "bold"), bg="#e0e0e0")
                lbl.grid(row=1, column=base_col + i, padx=2, pady=5, sticky="nsew")
            
            if col == 0 and num_cols_to_display > 1:
                sep_col = base_col + 9
                tk.Label(self.root, text="", width=4, bg="#f0f0f0").grid(row=1, column=sep_col, rowspan=34)

        for i, row_data in enumerate(self.rows):
            self._draw_single_row(i, row_data)
        
        self.recalculate_ok_err()

    def _draw_single_row(self, index, row_data):
        op_var, next_ok_var, next_err_var, reg_var, data_var, mask_var, _ = row_data
        
        col = index // 32
        row_grid = index % 32 + 2
        base_col = col * 10

        cb = tk.Checkbutton(self.root, variable=self.selected_rows_vars[index])
        cb.grid(row=row_grid, column=base_col + 0, padx=(5,0), pady=2)

        label = tk.Label(self.root, text=str(index), font=("Arial", 10), bg="#f8f8f8")
        label.grid(row=row_grid, column=base_col + 1, padx=2, pady=2, sticky="nsew")
        
        write_rb = tk.Radiobutton(self.root, text="W", variable=op_var, value="WRITE",
                                  indicatoron=0, width=2, selectcolor="#a0e0a0")
        write_rb.grid(row=row_grid, column=base_col + 2, padx=(5,1), pady=2)

        read_rb = tk.Radiobutton(self.root, text="R", variable=op_var, value="READ",
                                  indicatoron=0, width=2, selectcolor="#a0a0e0")
        read_rb.grid(row=row_grid, column=base_col + 3, padx=(1,5), pady=2)

        reg_display_list = [f"{reg['addr']} ({reg['name']})" for reg in REGISTROS]
        reg_menu = ttk.Combobox(self.root, textvariable=reg_var, values=reg_display_list, width=18)
        reg_menu.grid(row=row_grid, column=base_col + 4, padx=2, pady=2)
        reg_menu.bind("<<ComboboxSelected>>", 
                        lambda event, rv=reg_var, dv=data_var, mv=mask_var: 
                        self._on_register_selected(event, rv, dv, mv))

        data_entry = tk.Entry(self.root, textvariable=data_var, width=10)
        data_entry.grid(row=row_grid, column=base_col + 5, padx=2, pady=2)
        
        mask_entry = tk.Entry(self.root, textvariable=mask_var, width=10)
        mask_entry.grid(row=row_grid, column=base_col + 6, padx=2, pady=2)
        
        next_ok_entry = tk.Entry(self.root, textvariable=next_ok_var, width=5)
        next_ok_entry.grid(row=row_grid, column=base_col + 7, padx=2, pady=2)
        
        next_err_entry = tk.Entry(self.root, textvariable=next_err_var, width=5)
        next_err_entry.grid(row=row_grid, column=base_col + 8, padx=2, pady=2)

    def _on_register_selected(self, event, reg_var, data_var, mask_var):
        selected_value = reg_var.get()
        
        if "(" in selected_value:
            addr = selected_value.split("(")[0].strip().upper()
        else:
            addr = selected_value.strip().upper()

        if addr == "020":
            data_var.set("00000008")
            mask_var.set("00000008")
        elif addr == "10C":
            mask_var.set("00000000")
        elif addr == "108":
            mask_var.set("FFFFFFFF")
        
    def add_row(self):
        if len(self.rows) >= 64:
            messagebox.showwarning("Límite alcanzado", "No se pueden agregar más de 64 líneas.")
            return

        selected_indices = [i for i, var in enumerate(self.selected_rows_vars) if var.get() == 1]
        insert_idx = max(selected_indices) + 1 if selected_indices else len(self.rows)

        op_var = tk.StringVar(value="WRITE")
        next_ok_var = tk.StringVar()
        next_err_var = tk.StringVar()
        reg_var = tk.StringVar(value=f"{REGISTROS[0]['addr']} ({REGISTROS[0]['name']})")
        data_var = tk.StringVar(value="00000000")
        mask_var = tk.StringVar(value="FFFFFFFF")
        
        col = insert_idx // 32
        
        new_row_data = (op_var, next_ok_var, next_err_var, reg_var, data_var, mask_var, col)
        
        self.rows.insert(insert_idx, new_row_data)
        self.selected_rows_vars.insert(insert_idx, tk.IntVar(value=0))

        for var in self.selected_rows_vars:
            var.set(0)

        self.redraw_grid()

    def delete_selected_rows(self):
        indices_to_delete = [i for i, var in enumerate(self.selected_rows_vars) if var.get() == 1]

        if not indices_to_delete:
            messagebox.showwarning("Sin selección", "Por favor, seleccione una o más líneas para eliminar.")
            return

        if not messagebox.askyesno("Confirmar eliminación", f"¿Está seguro de que desea eliminar las {len(indices_to_delete)} líneas seleccionadas?"):
            return
            
        for index in sorted(indices_to_delete, reverse=True):
            del self.rows[index]
            del self.selected_rows_vars[index]
        
        self.redraw_grid()

    def show_toast(self, message):
        toast = tk.Toplevel(self.root)
        toast.overrideredirect(True)
        toast.config(bg="#333", padx=10, pady=5)
        
        label = tk.Label(toast, text=message, bg="#333", fg="white", font=("Arial", 10))
        label.pack()

        self.root.update_idletasks()
        root_x = self.root.winfo_x()
        root_y = self.root.winfo_y()
        root_width = self.root.winfo_width()
        root_height = self.root.winfo_height()

        toast.update_idletasks()
        toast_width = toast.winfo_width()
        toast_height = toast.winfo_height()

        x = root_x + (root_width // 2) - (toast_width // 2)
        y = root_y + (root_height // 2) - (toast_height // 2)

        toast.geometry(f"+{x}+{y}")
        toast.after(2000, toast.destroy)

    def show_help_window(self):
        help_win = tk.Toplevel(self.root)
        help_win.title("Ayuda - Registros AXI IIC")
        help_win.geometry("1100x700")
        help_win.minsize(1000, 600)
        self._draw_help_main_table(help_win, reset_size=True)

    def _draw_help_main_table(self, help_win, reset_size=False):
        for widget in help_win.winfo_children():
            widget.destroy()

        if reset_size:
            help_win.geometry("1100x700")
            help_win.minsize(1000, 600)

        main_frame = ttk.Frame(help_win, padding="10")
        main_frame.pack(fill="both", expand=True)

        headers = ["Dirección", "Nombre de Registro", "Descripción"]
        for col, h in enumerate(headers):
            lbl = tk.Label(main_frame, text=h, font=("Arial", 10, "bold"), bg="#e0e0e0")
            lbl.grid(row=0, column=col, padx=2, pady=5, sticky="nsew")

        for i, reg in enumerate(REGISTROS):
            addr = reg['addr']
            name = reg['name']
            desc = reg['desc']
            
            tk.Label(main_frame, text=addr+"h", font=("Arial", 9), bg="#f8f8f8").grid(row=i+1, column=0, padx=2, pady=2, sticky="nsew")
            btn = tk.Button(main_frame, text=name, font=("Arial", 9, "underline"), fg="blue", cursor="hand2",
                            relief=tk.FLAT, command=lambda a=addr: self._show_register_detail_inplace(help_win, a))
            btn.grid(row=i+1, column=1, padx=2, pady=2, sticky="nsew")
            tk.Label(main_frame, text=desc, font=("Arial", 9), bg="#f8f8f8", anchor="w").grid(row=i+1, column=2, padx=2, pady=2, sticky="nsew")

        for col in range(3):
            main_frame.grid_columnconfigure(col, weight=1)

    # <<< FUNCIÓN CORREGIDA Y MEJORADA >>>
    def _show_register_detail_inplace(self, help_win, addr):
        # Borra el contenido anterior de la ventana de ayuda
        for widget in help_win.winfo_children():
            widget.destroy()

        # --- Frame superior para el botón de retroceso y el título ---
        top_frame = tk.Frame(help_win)
        top_frame.pack(fill="x", padx=10, pady=(10, 0))

        def back_to_table():
            self._draw_help_main_table(help_win, reset_size=True)
        
        back_btn = tk.Button(top_frame, text="BACK", font=("Arial", 9), command=back_to_table)
        back_btn.pack(side="left", anchor="w")

        # --- Lógica mejorada para mostrar detalles ---
        
        # Busca la información detallada en HELP_TEXT
        detailed_info = HELP_TEXT.get(addr)

        if detailed_info:
            # CASE 1: Detailed bit info available. Show the table.
            title_label = ttk.Label(top_frame, text=detailed_info["title"], font=("Arial", 15, "bold"))
            title_label.pack(side="left", padx=(8, 0), anchor="w")

            tree_frame = ttk.Frame(help_win)
            tree_frame.pack(fill="both", expand=True, padx=10, pady=10)

            columns = ("name", "reset", "rw", "desc")
            tree = ttk.Treeview(tree_frame, columns=columns, show="tree headings")
            tree.heading("#0", text="Bits")
            tree.heading("name", text="Field Name")
            tree.heading("reset", text="Default Value")
            tree.heading("rw", text="Access Type")
            tree.heading("desc", text="Description")

            tree.column("#0", width=60, anchor="center", stretch=tk.NO)
            tree.column("name", width=150, anchor="w")
            tree.column("reset", width=100, anchor="center")
            tree.column("rw", width=150, anchor="w")
            tree.column("desc", width=500, anchor="w")

            for bit_info in detailed_info.get("bits", []):
                bit_range, bit_name, reset, rw, desc = bit_info
                tree.insert("", "end", text=bit_range, values=(bit_name, reset, rw, desc))

            scrollbar = ttk.Scrollbar(tree_frame, orient="vertical", command=tree.yview)
            tree.configure(yscrollcommand=scrollbar.set)
            tree.pack(side="left", fill="both", expand=True)
            scrollbar.pack(side="right", fill="y")
        else:
            # CASE 2: No detailed bit info. Show general description in English.
            reg_info = next((reg for reg in REGISTROS if reg['addr'] == addr), None)
            if reg_info:
                title_text = f"{reg_info['name']} - {reg_info['addr']}h"
                title_label = ttk.Label(top_frame, text=title_text, font=("Arial", 15, "bold"))
                title_label.pack(side="left", padx=(8, 0), anchor="w")

                info_frame = ttk.Frame(help_win, padding="10")
                info_frame.pack(fill="both", expand=True, padx=10, pady=10)

                main_desc_label = ttk.Label(info_frame, text=f"General Description: {reg_info['desc']}", font=("Arial", 11), wraplength=800)
                main_desc_label.pack(anchor="w", pady=(5,10))
                no_bits_label = ttk.Label(info_frame, text="No detailed bit information available for this register.", font=("Arial", 10, "italic"))
                no_bits_label.pack(anchor="w")
            else:
                # Fallback if register not found (should not occur)
                title_label = ttk.Label(top_frame, text="Error", font=("Arial", 15, "bold"))
                title_label.pack(side="left", padx=(8, 0), anchor="w")
                ttk.Label(help_win, text=f"No information found for address {addr}.").pack(padx=10, pady=10)

        help_win.update_idletasks()


    def _show_toast_in_window(self, win, message):
        toast = tk.Toplevel(win)
        toast.overrideredirect(True)
        toast.config(bg="#333", padx=10, pady=5)
        label = tk.Label(toast, text=message, bg="#333", fg="white", font=("Arial", 10))
        label.pack()
        win.update_idletasks()
        win_x = win.winfo_rootx()
        win_y = win.winfo_rooty()
        win_width = win.winfo_width()
        win_height = win.winfo_height()
        toast.update_idletasks()
        toast_width = toast.winfo_width()
        toast_height = toast.winfo_height()
        x = win_x + (win_width // 2) - (toast_width // 2)
        y = win_y + (win_height // 2) - (toast_height // 2)
        toast.geometry(f"+{x}+{y}")
        toast.after(2000, toast.destroy)

    def generate_files(self):
        dir_path = filedialog.askdirectory(title="Selecciona la carpeta para guardar los archivos .mem")
        if not dir_path:
            return

        data_lines, addr_lines, mask_lines, ctrl_lines = [], [], [], []
        
        for op_var, next_ok_var, next_err_var, reg_var, data_var, mask_var, _ in self.rows:
            op = op_var.get()
            reg_info = reg_var.get()
            
            if "(" in reg_info:
                reg_addr = reg_info.split("(")[0].strip().upper()
            else:
                reg_addr = reg_info.strip().upper()
            
            try:
                int(reg_addr, 16)
                reg_addr = reg_addr.zfill(3)
            except ValueError:
                reg_addr = "000"

            data = data_var.get().zfill(8)
            mask = mask_var.get().zfill(8)
            next_ok = next_ok_var.get().zfill(2)
            next_err = next_err_var.get().zfill(2)
            ctrl = "B" if op == "WRITE" else "A"
            ctrl_word = f"000{ctrl}{next_ok}{next_err}"
            
            data_lines.append(data)
            addr_lines.append(reg_addr.zfill(8))
            mask_lines.append(mask)
            ctrl_lines.append(ctrl_word)

        num_valid_lines = len(data_lines)
        for _ in range(num_valid_lines, 64):
            data_lines.append("FFFFFFFF")
            addr_lines.append("FFFFFFFF")
            mask_lines.append("FFFFFFFF")
            ctrl_lines.append("FFFFFFFF")

        try:
            with open(os.path.join(dir_path, "axi_stream_axi_traffic_gen_0_0_data.mem"), "w") as f:
                f.write("\n".join(data_lines))
            with open(os.path.join(dir_path, "axi_stream_axi_traffic_gen_0_0_addr.mem"), "w") as f:
                f.write("\n".join(addr_lines))
            with open(os.path.join(dir_path, "axi_stream_axi_traffic_gen_0_0_mask.mem"), "w") as f:
                f.write("\n".join(mask_lines))
            with open(os.path.join(dir_path, "axi_stream_axi_traffic_gen_0_0_ctrl.mem"), "w") as f:
                f.write("\n".join(ctrl_lines))
            
            self.show_toast(f"Archivos generados correctamente.")

        except Exception as e:
            messagebox.showerror("Error", f"No se pudo escribir en el directorio: {e}")

    def import_mem_files(self):
        dir_path = filedialog.askdirectory(title="Selecciona el directorio de los archivos .mem")
        if not dir_path:
            return
        try:
            with open(f"{dir_path}/axi_stream_axi_traffic_gen_0_0_data.mem", "r") as f:
                data_lines = [line.strip() for line in f.readlines()]
            with open(f"{dir_path}/axi_stream_axi_traffic_gen_0_0_addr.mem", "r") as f:
                addr_lines = [line.strip() for line in f.readlines()]
            with open(f"{dir_path}/axi_stream_axi_traffic_gen_0_0_mask.mem", "r") as f:
                mask_lines = [line.strip() for line in f.readlines()]
            with open(f"{dir_path}/axi_stream_axi_traffic_gen_0_0_ctrl.mem", "r") as f:
                ctrl_lines = [line.strip() for line in f.readlines()]
        except Exception as e:
            messagebox.showerror("Error", f"No se pudieron leer los archivos: {e}")
            return
            
        self.rows.clear()
        self.selected_rows_vars.clear()
        
        last_idx = len(addr_lines)
        try:
            last_idx = addr_lines.index("FFFFFFFF")
        except ValueError:
            pass

        for idx in range(last_idx):
            ctrl = ctrl_lines[idx]
            op_code = ctrl[3].upper()
            op = "WRITE" if op_code == "B" else ("READ" if op_code == "A" else "?")
            reg_addr = addr_lines[idx][-3:].upper()
            
            reg_name = next((reg['name'] for reg in REGISTROS if reg['addr'] == reg_addr), "Custom")
            reg_val = f"{reg_addr} ({reg_name})"
            
            op_var = tk.StringVar(value=op)
            next_ok_var = tk.StringVar(value=ctrl[4:6])
            next_err_var = tk.StringVar(value=ctrl[6:8])
            reg_var = tk.StringVar(value=reg_val)
            data_var = tk.StringVar(value=data_lines[idx])
            mask_var = tk.StringVar(value=mask_lines[idx])
            col = idx // 32
            
            self.rows.append((op_var, next_ok_var, next_err_var, reg_var, data_var, mask_var, col))
            self.selected_rows_vars.append(tk.IntVar(value=0))

        self.redraw_grid()
        self.show_toast(f"Se importaron {last_idx} líneas.")

if __name__ == "__main__":
    root = tk.Tk()
    app = MemGenApp(root)
    root.mainloop()