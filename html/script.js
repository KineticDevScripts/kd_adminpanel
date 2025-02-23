let selectedPlayerId = null;
let selectedResource = null;

const body = document.querySelector('body'),
  sidebar = body.querySelector('nav'),
  toggle = body.querySelector(".toggle"),
  modeSwitch = body.querySelector(".toggle-switch"),
  modeText = body.querySelector(".mode-text");

// Toggle sidebar visibility
toggle.addEventListener("click", () => {
  sidebar.classList.toggle("close");
})

// Toggle dark mode and update mode text
modeSwitch.addEventListener("click", () => {
  body.classList.toggle("dark");

  // Update mode text based on the current mode
  if (body.classList.contains("dark")) {
    modeText.innerText = "Light mode";
    showNotification("Switched To Dark Mode", 'success', 5000);
  } else {
    modeText.innerText = "Dark mode";
    showNotification("Switched To Light Mode", 'success', 5000);
  }
});

// Fetch data on load
document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("resourceSearch");
  const resourceTableBody = document.querySelector("#resources-table tbody");

  if (!searchInput || !resourceTableBody) {
      console.error("Missing elements for resource search.");
      return;
  }

  searchInput.addEventListener("input", () => {
      const query = searchInput.value.toLowerCase();
      resourceTableBody.querySelectorAll("tr").forEach(row => {
          const textContent = row.innerText.toLowerCase();
          row.style.display = textContent.includes(query) ? "" : "none";
      });
  });

  nuiCallBack('getHeaderData');
});

// Listener
window.addEventListener("message", (event) => {
  const { action, uptime, players, resources, log, header } = event.data;

  switch (action) {
      case "showMenu":
          document.getElementById("menu-container").style.display = "flex";
          fetchDashboardData();
          fetchPlayers();
          fetchServerItems();
          fetchResources();
          break;
      case "hideMenu":
          document.getElementById("menu-container").style.display = "none";
          break;
      case "updateHeader":
          const body = document.querySelector('body');
          const adminLogo = body.querySelector('.image img');
          const topText = body.querySelector('.text.logo-text .top-text');
          const bottomText = body.querySelector('.text.logo-text .bottom-text');
          
          if (adminLogo && header.logo) {
            adminLogo.src = header.logo;
          } else {
            console.error('Logo image or source is missing');
          }

          if (topText && header.topText) {
            topText.textContent = header.topText;  
          } else {
            console.error('Top text or source is missing');
          }

          if (bottomText && header.bottomText) {
            bottomText.textContent = header.bottomText;  
          } else {
            console.error('Bottom text or source is missing');
          }
          break;          
      case "updateUptime":
          document.getElementById('server-uptime').innerText = uptime;
          break;
      case "updatePlayerList":
          updatePlayerTable(players);
          break;
      case "updateResourceList":
          updateResourceTable(resources);
          break;
      case "updateLogs":
          if (log) {
              const row = document.createElement('tr');
              row.innerHTML = `
                  <td>${log.timestamp}</td>
                  <td>${log.action}</td>
                  <td>${log.admin}</td>
                  <td>${log.target}</td>
                  <td>${log.details}</td>
              `;
              document.getElementById('logs-table-body').appendChild(row);
          }
          break;
  }
});

// Close menu on esc
document.addEventListener("keydown", (event) => {
  if (event.key === "Escape") closeMenu();
});

// Open tab
function openTab(tabId) {
  const tabs = document.querySelectorAll(".tab");
  
  tabs.forEach((tab) => tab.classList.remove("active"));
  document.getElementById(tabId).classList.add("active");
}

// Open and close dialog
function openDialog(dialogId) { 
  document.getElementById(dialogId).classList.add("active");
}

function closeDialog(dialogId) {
  document.getElementById(dialogId).classList.remove("active");
}

// Show notification
function showNotification(message, type = 'info', duration = 3000) {
  const container = document.getElementById('notify-container');
  const notify = document.createElement('div');
  notify.className = `notify ${type}`;

  const icons = { success: '✅', error: '❌', warning: '⚠️', info: 'ℹ️' };
  const icon = icons[type] || icons.info;

  notify.innerHTML = `
      <span class="icon">${icon}</span>
      <span>${message}</span>
      <button class="close-btn">&times;</button>
      <div class="progress-bar" style="animation-duration: ${duration}ms"></div>
  `;

  notify.querySelector('.close-btn').addEventListener('click', () => notify.remove());
  container.prepend(notify);

  setTimeout(() => notify.classList.add('show'), 10);
  setTimeout(() => {
      notify.classList.remove('show');
      setTimeout(() => notify.remove(), 300);
  }, duration);
}

////// START DASHBOARD //////

// Fetch dashoard data
async function fetchDashboardData() {
  try {
      const data = await nuiCallBack('getDashboardData', { action: 'getDashboardData' });
      document.getElementById('resource-count').innerText = data.resourceCount;
      document.getElementById('player-count').innerText = data.playerCount + ' Players';
      document.getElementById('server-uptime').innerText = data.uptime;
      document.getElementById('server-version').innerText = data.version;
  } catch (err) {
      console.error('Error fetching dashboard data:', err);
  }
}

async function fetchServerItems() {
  try {
      const items = await nuiCallBack('getServerItems', { action: 'getServerItems' });
      const selfItemSelect = document.getElementById('selfItemName');
      const playerItemSelect = document.getElementById('playerItemName');

      if (!selfItemSelect || !playerItemSelect) return console.error('Item select elements not found.');

      selfItemSelect.innerHTML = playerItemSelect.innerHTML = `<option value="">Select an item</option>`;

      items.forEach(item => {
          const option = new Option(item.label, item.name);
          selfItemSelect.appendChild(option.cloneNode(true));
          playerItemSelect.appendChild(option);
      });
  } catch (error) {
      console.error('Error fetching items:', error);
  }
}

async function fetchPlayerItems(playerId) {
  if (!playerId) return console.error("No player ID provided for inventory fetch.");

  try {
      const response = await fetch(`https://${GetParentResourceName()}/getPlayerItems`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ playerId })
      });

      const items = await response.json();
      const itemSelect = document.getElementById('removePlayerItemName');
      if (!itemSelect) return;

      itemSelect.innerHTML = `<option value="">Select an item</option>`;

      if (!items.length) return console.warn("No items received for player:", playerId);

      items.forEach(item => {
          const option = new Option(item.label, item.name);
          itemSelect.appendChild(option);
      });
  } catch (error) {
      console.error('Error fetching player items:', error);
  }
}

////// END DASHBOARD //////

////// START ADMIN ACTIONS //////

document.getElementById("selfMoney-amount").addEventListener("wheel", function (e) {
  e.preventDefault();
});


function selfRevive() {
  nuiCallBack('selfRevive')
}

function selfHeal() {
  nuiCallBack('selfHeal')
}

function enforceMax(input) {
  if (parseInt(input.value, 10) > 999999999) {
    input.value = 999999999; 
  }
}

function confirmSelfMoney() {
  let account = document.getElementById("selfMoney-accountType").value.trim();
  let amountInput = document.getElementById("selfMoney-amount");
  let amount = parseInt(amountInput.value, 10);

  if (!account) {
    console.log("Please select a valid account type!");
    return;
  }

  if (Number.isNaN(amount) || amount < 1) {
    console.log("Please enter a valid amount!");
    return;
  }

  if (amount > 999999999) {
    console.log("Maximum is 999,999,999!");
    return;
  }

  nuiCallBack('giveSelfMoney', { account, amount });

  closeDialog('selfMoney');
}

function confirmSelfItem() {
  const itemInput = document.getElementById("selfItemName");
  const amountInput = document.getElementById("selfItemQuantity");

  const item = itemInput?.value.trim();
  const amount = parseInt(amountInput?.value, 10);

  if (!item) {
    console.error("Please enter a valid item name.");
    return;
  }

  if (isNaN(amount) || amount < 1) {
    console.error("Please enter a valid amount.");
    return;
  }

  nuiCallBack("giveSelfItem", { item, amount });
  closeDialog("selfItem");
}

function toggleNoClip() {
  nuiCallBack('toggleNoClip');
}

function toggleInvisibility() {
  nuiCallBack('toggleInvisibility');
}

function toggleGodMode() {
  nuiCallBack('toggleGodMode');
}

function confirmSpawnCar() {
  let model = document.getElementById("carModel").value.trim(); 

  if (model.length === 0) {
    console.error("Car model is required.");
  } else {
    nuiCallBack('spawnCar', { model });
  }

  closeDialog('spawnCar');
}

function deleteVehicle() {
  nuiCallBack('deleteVehicle');
}

function repairVehicle() {
  nuiCallBack('repairVehicle');
}

function confirmAnnouncement() {
  let msg = document.getElementById("announcementMsg").value;

  if (msg.length === 0) {
    console.error("Announcement message is required.");
  } else {
    nuiCallBack('sendAnnouncement', { msg: msg });
  }

  closeDialog('announcement');
}

function deleteVehicles() {
  nuiCallBack('deleteVehicles');
}

function deleteObjects() {
  nuiCallBack('deleteObjects');
}

function deletePeds() {
  nuiCallBack('deletePeds');
}

function confirmCoords() {
  let type = document.getElementById("coordsType").value;
  
  if (type.length === 0) {
      console.log("Please select a valid type!");
      return;
  }

  nuiCallBack('copyCoords', { type: type });

  closeDialog('copyCoords');
}

function confirmTp() {
  const input = document.getElementById("tp_vec3").value.trim();
  const coords = input.split(",").map(num => parseFloat(num.trim()));

  if (coords.length === 3 && coords.every(num => !isNaN(num))) {
      nuiCallBack('tpToCoords', { coords });

      closeDialog('tpCoords');
  } else {
      console.log("Invalid format! Use: x, y, z (e.g., 200.0, 300.0, 50.0)");
  }
}

////// END ADMIN ACTIONS //////

////// START ONLINE PLAYERS //////
function fetchPlayers() {
  nuiCallBack('requestPlayers')
}

function updatePlayerTable(players) {
  let tableBody = document.querySelector("#online-table tbody");
  tableBody.innerHTML = "";
  
  players.forEach(player => {
      let row = document.createElement("tr");
      row.classList.add("table-row-online");

      row.innerHTML = `
          <td class="online-name">${player.name}</td>
          <td class="online-id">${player.id}</td>
      `;
      row.addEventListener("click", function() {
          selectPlayer(player);
      });
      tableBody.appendChild(row);
  });
}

function selectPlayer(player) {
  openTabWithData('selectedPlayer', player)
  fetchPlayerItems(selectedPlayerId)
}

function openTabWithData(tabId, player) {
  const tabs = document.querySelectorAll(".tab");
  tabs.forEach((tab) => tab.classList.remove("active"));
  document.getElementById(tabId).classList.add("active");

  document.getElementById('selected-player-name').innerText = `Name: ${player.name}`;
  document.getElementById('selected-player-id').innerText = `ID: ${player.id}`;
  document.getElementById('selected-player-job').innerText = `Job: ${player.job}`;
  document.getElementById('selected-player-cash').innerText = `Cash: $${player.cash}`;
  document.getElementById('selected-player-bank').innerText = `Bank: $${player.bank}`;
  selectedPlayerId = player.id;
}

function confirmKick() {
  if (!selectedPlayerId) {
    console.error("No player selected.");
    return;
  }

  const reasonInput = document.getElementById("kickReason");
  const reason = reasonInput?.value.trim();

  if (!reason) {
    console.error("Kick reason is required.");
    return;
  }

  nuiCallBack("kickPlayer", { playerId: selectedPlayerId, reason });
  closeDialog("kick");
  openTab('players');
}

function confirmBan() {
  if (!selectedPlayerId) {
    console.error("No player selected.");
    return;
  }

  const reasonInput = document.getElementById("banReason");
  const timeInput = document.getElementById("banTime");

  const reason = reasonInput?.value.trim();
  const time = timeInput?.value.trim();

  if (!reason) {
    console.error("Ban reason is required.");
    return;
  }

  if (!time) {
    console.error("Ban time is required.");
    return;
  }

  nuiCallBack("banPlayer", { playerId: selectedPlayerId, reason, time });
  closeDialog("ban");
  openTab('players');
}

function spectatePlayer() {
  if (selectedPlayerId) {
    nuiCallBack("spectatePlayer", { playerId: selectedPlayerId });
  }
}

function gotoPlayer() {
  if (selectedPlayerId) {
    nuiCallBack("gotoPlayer", { playerId: selectedPlayerId });
  }
}

function bringPlayer() {
  if (selectedPlayerId) {
    nuiCallBack("bringPlayer", { playerId: selectedPlayerId });
  }
}

function revivePlayer() {
  if (selectedPlayerId) {
    nuiCallBack("revivePlayer", { playerId: selectedPlayerId });
  }
}

function healPlayer() {
  if (selectedPlayerId) {
    nuiCallBack("healPlayer", { playerId: selectedPlayerId });
  }
}

function confirmPlayerMoney() {
  const account = document.getElementById("playerMoney-accountType").value.trim();
  const amountInput = document.getElementById("playerMoney-amount");
  const amount = parseInt(amountInput.value, 10);
  const maxAmount = 999999999;

  if (!selectedPlayerId) {
    console.error("No player selected.");
    return;
  }

  if (!account) {
    return console.error("Please select a valid account type!");
  }

  if (isNaN(amount) || amount < 1) {
    return console.error("Please enter a valid amount!");
  }

  if (amount > maxAmount) {
    return console.error(`Maximum allowed amount is ${maxAmount.toLocaleString()}!`);
  }

  nuiCallBack("givePlayerMoney", { playerId: selectedPlayerId, account, amount });
  closeDialog("playerMoney");
}

function confirmRemovePlayerMoney() {
  const account = document.getElementById("removePlayerMoney-accountType").value.trim();
  const amountInput = document.getElementById("removePlayerMoney-amount");
  const amount = parseInt(amountInput.value, 10);
  const maxAmount = 999999999;

  if (!selectedPlayerId) {
    console.error("No player selected.");
    return;
  }

  if (!account) {
    return console.error("Please select a valid account type!");
  }

  if (isNaN(amount) || amount < 1) {
    return console.error("Please enter a valid amount!");
  }

  if (amount > maxAmount) {
    return console.error(`Maximum allowed amount is ${maxAmount.toLocaleString()}!`);
  }

  nuiCallBack("removePlayerMoney", { playerId: selectedPlayerId, account, amount });
  closeDialog("removePlayerMoney");
}

function confirmPlayerJob() {
  const job = document.getElementById("pJob").value;
  const grade = document.getElementById("pGrade").value;

  if (!selectedPlayerId) {
    console.error("No player selected.");
    return;
  }

  if (!job) {
    return console.error("Please enter a valid job!");
  }

  if (grade < 1) {
    return console.error("Please enter a valid grade!");
  }

  nuiCallBack("setPlayerJob", { playerId: selectedPlayerId, job, grade });
  closeDialog("playerJob");
}

function confirmPlayerItem() {
  const itemInput = document.getElementById("playerItemName");
  const amountInput = document.getElementById("playerItemQuantity");

  if (!selectedPlayerId) {
    console.error("No player selected.");
    return;
  }

  const item = itemInput?.value.trim();
  const amount = parseInt(amountInput?.value, 10);

  if (!item) {
    console.error("Please enter a valid item name.");
    return;
  }

  if (isNaN(amount) || amount < 1) {
    console.error("Please enter a valid amount.");
    return;
  }

  nuiCallBack("givePlayerItem", { playerId: selectedPlayerId, item, amount });
  fetchPlayerItems(selectedPlayerId)
  closeDialog("playerItem");
}

function confirmRemovePlayerItem() {
  if (!selectedPlayerId) {
      console.error("No player selected.");
      return;
  }

  const item = document.getElementById("removePlayerItemName").value.trim();
  let amount = parseInt(document.getElementById("removePlayerItemQuantity").value, 10);

  if (!item) {
      alert("Please select a valid item!");
      return;
  }

  if (!Number.isInteger(amount) || amount < 1) {
      alert("Please enter a valid amount!");
      return;
  }

  nuiCallBack("removePlayerItem", { playerId: selectedPlayerId, item, amount });
  fetchPlayerItems(selectedPlayerId)
  closeDialog("removePlayerItem");
}
////// END ONLINE PLAYERS //////

////// START RESOURCES //////
function fetchResources() {
  fetch("https://kd_adminpanel/requestResources", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({})
  });
}

function updateResourceTable(resources) {
  let tableBody = document.querySelector("#resources-table tbody");
  tableBody.innerHTML = "";
  
  resources.forEach(resource => {
      let row = document.createElement("tr");
      row.classList.add("table-row-resources");

      row.innerHTML = `
          <td class="resources-name">${resource.name}</td>
          <td class="resources-state">${resource.state}</td>
      `;
      row.addEventListener("click", function() {
          selectResource(resource.name, resource.state);
      });
      tableBody.appendChild(row);
  });
}

function selectResource(resourceName, resourceState) {
  openManageResourceMenu(resourceName, resourceState)
}

function openManageResourceMenu(resourceName, resourceState) {
  selectedResource = resourceName;
  document.getElementById('selected-resource-name').textContent = `Selected Resource: ${resourceName}`;
  document.getElementById('manage-resource-menu').style.display = 'block';
}

function closeManageResourceMenu() {
  document.getElementById('manage-resource-menu').style.display = 'none';
}

function restartResource() {
  if (selectedResource) {
    fetch(`https://${GetParentResourceName()}/restartResource`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resource: selectedResource })
    });
  }
  closeManageResourceMenu();
  fetchResources()
}

function startResource() {
  if (selectedResource) {
    fetch(`https://${GetParentResourceName()}/startResource`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resource: selectedResource })
    });
  }
  closeManageResourceMenu();
  fetchResources()
}

function stopResource() {
  if (selectedResource) {
    fetch(`https://${GetParentResourceName()}/stopResource`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ resource: selectedResource })
    });
  }
  closeManageResourceMenu();
  fetchResources()
}
////// END RESOOURCES //////

// Close menu
function closeMenu() {
  nuiCallBack("closeMenu")
}

// Callback
async function nuiCallBack(endpoint, data = {}) {
  const response = await fetch(`https://${GetParentResourceName()}/${endpoint}`, {
      method: 'POST',
      body: JSON.stringify(data),
      headers: {
          'Content-Type': 'application/json'
      }
  });
  return await response.json();
}