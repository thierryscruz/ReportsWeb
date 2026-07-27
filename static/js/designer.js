/**
 * designer.js – Lógica do Designer de Colunas e Configurador de Filtros
 * Usado na página admin/report_form.html
 */

// ════════════════════════════════════════════════════════════════════════════
//  DETECT COLUMNS (chamada à API)
// ════════════════════════════════════════════════════════════════════════════
document.getElementById('btn-detect')?.addEventListener('click', async () => {
  const sql    = document.getElementById('sql-editor').value.trim();
  const btn    = document.getElementById('btn-detect');
  const result = document.getElementById('detect-result');

  if (!sql) {
    showDetectResult('error', 'Cole o SQL antes de detectar as colunas.');
    return;
  }

  btn.innerHTML = '<span class="spinner"></span> Detectando…';
  btn.disabled  = true;

  try {
    // Se window.APP_ROOT for '/', fica '/admin/...'. Se for '/RelAcessoApp/', fica '/RelAcessoApp/admin/...'
    const apiUrl = window.APP_ROOT + 'admin/relatorios/detectar-colunas';
    const resp = await fetch(apiUrl, {
      method : 'POST',
      headers: { 'Content-Type': 'application/json' },
      body   : JSON.stringify({ sql })
    });
    const data = await resp.json();

    if (data.ok) {
      populateAvailableColumns(data.columns);
      showDetectResult('success', `${data.columns.length} coluna(s) detectada(s). Adicione-as ao relatório →`);
    } else {
      showDetectResult('error', data.error || 'Erro ao detectar colunas.');
    }
  } catch (e) {
    showDetectResult('error', 'Erro de conexão: ' + e.message);
  } finally {
    btn.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles"></i> Detectar Colunas';
    btn.disabled  = false;
  }
});

function showDetectResult(type, msg) {
  const el = document.getElementById('detect-result');
  el.style.display  = 'block';
  el.className      = `alert alert-${type}`;
  el.innerHTML      = `<i class="fa-solid fa-${type === 'success' ? 'check-circle' : 'circle-xmark'}"></i> ${msg}`;
}

// ════════════════════════════════════════════════════════════════════════════
//  COLUMN DESIGNER
// ════════════════════════════════════════════════════════════════════════════
const availableList = document.getElementById('available-cols');
const selectedList  = document.getElementById('selected-cols');

function populateAvailableColumns(cols) {
  availableList.innerHTML = '';
  // Get already selected column keys
  const selected = getSelectedColumnKeys();
  cols.forEach(col => {
    const item = makeAvailableItem(col);
    if (selected.includes(col.toUpperCase())) {
      item.style.opacity = '0.4';
    }
    availableList.appendChild(item);
  });
}

function makeAvailableItem(colName) {
  const li = document.createElement('li');
  li.className   = 'designer-item';
  li.dataset.col = colName;
  li.innerHTML   = `
    <i class="fa-solid fa-database" style="color:var(--text-muted);font-size:11px;"></i>
    <span style="flex:1;font-family:monospace;font-size:11px;">${colName}</span>
    <button type="button" class="btn btn-primary btn-sm btn-icon" title="Adicionar">
      <i class="fa-solid fa-plus"></i>
    </button>
  `;
  li.querySelector('button').addEventListener('click', () => addColumn(colName));
  return li;
}

function getSelectedColumnKeys() {
  return Array.from(selectedList.querySelectorAll('.designer-item'))
    .map(li => li.dataset.col.toUpperCase());
}

function addColumn(colName) {
  // Check if already added
  if (getSelectedColumnKeys().includes(colName.toUpperCase())) return;

  const li = makeSelectedItem(colName, colName.replace(/_/g, ' '));
  selectedList.appendChild(li);
  initDragDrop(li);
  updateColumnsInput();
}

function makeSelectedItem(colKey, label, align = 'left') {
  const li = document.createElement('li');
  li.className   = 'designer-item';
  li.draggable   = true;
  li.dataset.col = colKey;
  li.innerHTML   = `
    <span class="drag-handle"><i class="fa-solid fa-grip-vertical"></i></span>
    <input class="col-label-input" type="text" value="${label}" placeholder="Título da coluna">
    <select class="form-control" style="width:80px;padding:3px 6px;font-size:11px;background:rgba(255,255,255,0.05);">
      <option value="left"   ${align==='left'  ?'selected':''}>← Esq</option>
      <option value="center" ${align==='center'?'selected':''}>⎔ Cen</option>
      <option value="right"  ${align==='right' ?'selected':''}>→ Dir</option>
    </select>
    <button type="button" class="col-remove" title="Remover"><i class="fa-solid fa-xmark"></i></button>
  `;
  // Remove button
  li.querySelector('.col-remove').addEventListener('click', () => {
    li.remove();
    updateColumnsInput();
  });
  // Update on label change
  li.querySelector('.col-label-input').addEventListener('input', updateColumnsInput);
  li.querySelector('select').addEventListener('change', updateColumnsInput);
  return li;
}

function updateColumnsInput() {
  const items = Array.from(selectedList.querySelectorAll('.designer-item'));
  const config = items.map((li, idx) => ({
    coluna_sql      : li.dataset.col,
    titulo_exibicao : li.querySelector('.col-label-input').value,
    alinhamento     : li.querySelector('select').value,
    largura         : 150,
    visivel         : true,
    ordem           : idx
  }));
  document.getElementById('columns-config-input').value = JSON.stringify(config);
}

// ── Drag and Drop ─────────────────────────────────────────────────────────
let dragSrc = null;

function initDragDrop(item) {
  item.addEventListener('dragstart', e => {
    dragSrc = item;
    item.classList.add('dragging');
    e.dataTransfer.effectAllowed = 'move';
  });
  item.addEventListener('dragend', () => {
    dragSrc = null;
    item.classList.remove('dragging');
    document.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over'));
    updateColumnsInput();
  });
  item.addEventListener('dragover', e => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
    if (dragSrc && dragSrc !== item) item.classList.add('drag-over');
  });
  item.addEventListener('dragleave', () => item.classList.remove('drag-over'));
  item.addEventListener('drop', e => {
    e.preventDefault();
    item.classList.remove('drag-over');
    if (dragSrc && dragSrc !== item) {
      const items  = Array.from(selectedList.querySelectorAll('.designer-item'));
      const srcIdx = items.indexOf(dragSrc);
      const tgtIdx = items.indexOf(item);
      if (srcIdx < tgtIdx) {
        selectedList.insertBefore(dragSrc, item.nextSibling);
      } else {
        selectedList.insertBefore(dragSrc, item);
      }
      updateColumnsInput();
    }
  });
}

// Init drag-drop on existing items
selectedList.querySelectorAll('.designer-item').forEach(initDragDrop);
// Init remove buttons on existing items
selectedList.querySelectorAll('.col-remove').forEach(btn => {
  btn.addEventListener('click', () => { btn.closest('.designer-item').remove(); updateColumnsInput(); });
});

// Initial state
updateColumnsInput();

// ════════════════════════════════════════════════════════════════════════════
//  FILTER BUILDER
// ════════════════════════════════════════════════════════════════════════════
const filtersContainer = document.getElementById('filters-container');

document.getElementById('btn-add-filter')?.addEventListener('click', () => {
  addFilterRow('', 'text', '', false);
});

function addFilterRow(param, tipo, label, required, sqlOpts = '', placeholder = '') {
  const row = document.createElement('div');
  row.className = 'filter-row';
  row.setAttribute('data-filter', '');
  row.innerHTML = `
    <div>
      <label class="form-label">Parâmetro SQL</label>
      <input class="form-control form-control-plain" type="text" placeholder=":nome_param"
             value="${param}" data-field="parametro">
    </div>
    <div>
      <label class="form-label">Tipo</label>
      <select class="form-control" data-field="tipo">
        ${['text','date','number','select','multiselect','checkbox'].map(t =>
          `<option value="${t}" ${t===tipo?'selected':''}>${t}</option>`
        ).join('')}
      </select>
    </div>
    <div>
      <label class="form-label">Rótulo (label)</label>
      <input class="form-control form-control-plain" type="text" placeholder="Ex: Data Início"
             value="${label}" data-field="label">
      <div style="margin-top:6px;">
        <label style="display:flex;align-items:center;gap:6px;font-size:11px;color:var(--text-muted);cursor:pointer;">
          <input type="checkbox" ${required?'checked':''} data-field="obrigatorio"
                 style="accent-color:var(--blue);">
          Obrigatório
        </label>
      </div>
    </div>
    <div>
      <button type="button" class="filter-remove">
        <i class="fa-solid fa-xmark"></i>
      </button>
    </div>
    <div class="sql-options-container" style="display: ${['select','multiselect'].includes(tipo) ? 'block' : 'none'}; margin-top: 8px; grid-column: 1 / -1;">
      <label class="form-label">SQL para Popular a Lista (obrigatório retornar colunas 'value' e 'label')</label>
      <textarea class="form-control" data-field="sql_opcoes" rows="2" 
                placeholder="Ex: SELECT LOCA_ID as value, LOCA_NOME as label FROM FORACESSO.LOCAL_ACESSO">${sqlOpts}</textarea>
    </div>
  `;
  row.querySelector('.filter-remove').addEventListener('click', () => {
    row.remove();
    updateFiltersInput();
  });
  row.querySelectorAll('input,select,textarea').forEach(el => {
    el.addEventListener('change', updateFiltersInput);
    el.addEventListener('input',  updateFiltersInput);
  });
  
  // Toggle sql options on type change
  row.querySelector('select[data-field="tipo"]').addEventListener('change', function() {
    const container = row.querySelector('.sql-options-container');
    if (this.value === 'select' || this.value === 'multiselect') {
      container.style.display = 'block';
    } else {
      container.style.display = 'none';
    }
  });
  
  filtersContainer.appendChild(row);
  updateFiltersInput();
}

// Global function for jinja-rendered rows
window.toggleSqlOptions = function(selectEl) {
  const container = selectEl.closest('.filter-row').querySelector('.sql-options-container');
  if (selectEl.value === 'select' || selectEl.value === 'multiselect') {
    container.style.display = 'block';
  } else {
    container.style.display = 'none';
  }
};

// Init existing filter rows
filtersContainer.querySelectorAll('[data-filter]').forEach(row => {
  row.querySelector('.filter-remove')?.addEventListener('click', () => {
    row.remove(); updateFiltersInput();
  });
  row.querySelectorAll('input,select,textarea').forEach(el => {
    el.addEventListener('change', updateFiltersInput);
    el.addEventListener('input',  updateFiltersInput);
  });
});

function updateFiltersInput() {
  const rows = Array.from(filtersContainer.querySelectorAll('[data-filter]'));
  const config = rows.map((row, idx) => {
    const param  = (row.querySelector('[data-field=parametro]')?.value || '').trim().replace(/^:/,'');
    const tipo   = row.querySelector('[data-field=tipo]')?.value || 'text';
    const label  = row.querySelector('[data-field=label]')?.value || '';
    const req    = row.querySelector('[data-field=obrigatorio]')?.checked || false;
    const sqlOpt = (row.querySelector('[data-field=sql_opcoes]')?.value || '').trim();
    return { parametro: param, tipo, label, obrigatorio: req, sql_opcoes: sqlOpt, valor_padrao: '', placeholder: '', ordem: idx };
  }).filter(f => f.parametro);
  document.getElementById('filters-config-input').value = JSON.stringify(config);
}
updateFiltersInput();

// ════════════════════════════════════════════════════════════════════════════
//  FORM SUBMIT guard
// ════════════════════════════════════════════════════════════════════════════
document.getElementById('report-save-form')?.addEventListener('submit', () => {
  updateColumnsInput();
  updateFiltersInput();
  const btn = document.getElementById('btn-save');
  btn.innerHTML = '<span class="spinner"></span> Salvando…';
  btn.disabled  = true;
});
